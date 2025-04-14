import QtQuick
import QtQuick.Controls
import QtQuick3D
Window {
    width: 1280
    height: 720
    visible: true
    title: qsTr("Hello World")
    color: "#000"
    View3D{
        id: scene3d
        anchors.fill: parent
        focus: true
        visible: true
        environment: SceneEnvironment {
            clearColor: "#00000000"
            backgroundMode: SceneEnvironment.Color
            antialiasingMode: SceneEnvironment.MSAA
            antialiasingQuality: SceneEnvironment.High
        }
        DirectionalLight{
            rotation.x: lx.value
            rotation.y: 1//ly.value
            rotation.z: 0.5 //lz.value
        }
        AnyConv_com__su7{
            id:model
            z:-5
        }
        MouseArea {
            anchors.fill: parent
            // 1. 正确定义初始参数
            property vector3d targetPosition: Qt.vector3d(0, 0.6, 0)
            property real initialDistance: targetPosition.minus(Qt.vector3d(0, 0, -7)).length()
            property quaternion initialRotation: Qt.quaternion(1, 0, 0, 0)//Qt.quaternion(0.228173, -0.0493328, 0.95041, 0.205486)

            // 2. 运行时状态
            property real currentDistance: initialDistance
            property quaternion currentRotation: initialRotation
            property point lastMousePos: Qt.point(0, 0)

            // 新增视角限制参数（单位：角度）
            property real minPitch: -45 // 向下俯视最大角度（负值表示向下）
            property real maxPitch: 0   // 向上仰视最大角度（正值表示向上）
            property real currentPitch: 0 // 当前俯仰角
            
            // 改进的方向控制系统
            property vector3d upVector: Qt.vector3d(0, 1, 0)
            property vector3d rightVector: Qt.vector3d(1, 0, 0)
            property quaternion accumulatedRotation: Qt.quaternion(1, 0, 0, 0)
            property bool isFirstMove: true
            
            // 计算实际旋转方向
            function calculateRotationDirection(mouseX, mouseY) {
                var currentUp = rotateVector(currentRotation, Qt.vector3d(0, 1, 0))
                var currentRight = rotateVector(currentRotation, Qt.vector3d(1, 0, 0))
                
                // 计算当前朝向与世界坐标系的点积
                var upDot = currentUp.dotProduct(Qt.vector3d(0, 1, 0))
                
                // 根据朝向调整控制方向
                var dx = (mouseX - lastMousePos.x) * 0.1
                var dy = (mouseY - lastMousePos.y) * 0.1
                
                // 当相机"倒置"时反转水平旋转
                if (upDot < 0) {
                    dx = -dx
                }
                
                return Qt.vector2d(dx, dy)
            }
            
            function normalizeQuaternion(q) {
                var len = Math.sqrt(q.scalar*q.scalar + q.x*q.x + q.y*q.y + q.z*q.z)
                if (len <= 0) return Qt.quaternion(1, 0, 0, 0)
                return Qt.quaternion(q.scalar/len, q.x/len, q.y/len, q.z/len)
            }
            
            // 改进的相机更新方法
            function updateCameraRotation(dx, dy) {
                if (isFirstMove) {
                    accumulatedRotation = currentRotation
                    isFirstMove = false

                    // 初始化当前俯仰角
                    var forward = rotateVector(accumulatedRotation, Qt.vector3d(0, 0, -1))
                    currentPitch = Math.asin(forward.y) * (180/Math.PI)
                }

                // 1. 先处理水平旋转（不受限制）
                var yawRot = angleAxisToQuat(dx, Qt.vector3d(0, 1, 0))
                accumulatedRotation = multiplyQuaternion(yawRot, accumulatedRotation)

                // 2. 计算允许的俯仰旋转量
                var requestedPitchChange = -dy  // 注意这里的负号：向下移动鼠标应该向下看
                var newPitch = currentPitch + requestedPitchChange

                // 确保俯仰角在允许范围内 (minPitch < maxPitch)
                if (newPitch < minPitch) {
                    requestedPitchChange = minPitch - currentPitch
                    newPitch = minPitch
                } else if (newPitch > maxPitch) {
                    requestedPitchChange = maxPitch - currentPitch
                    newPitch = maxPitch
                }

                // 3. 应用受限制的俯仰旋转
                if (Math.abs(requestedPitchChange) > 0.001) {
                    var currentRight = rotateVector(accumulatedRotation, Qt.vector3d(1, 0, 0))
                    var pitchRot = angleAxisToQuat(requestedPitchChange, currentRight)
                    accumulatedRotation = multiplyQuaternion(pitchRot, accumulatedRotation)
                    currentPitch = newPitch  // 直接设置为计算后的新值，避免累积误差
                }

                // 4. 规范化并应用最终旋转
                accumulatedRotation = normalizeQuaternion(accumulatedRotation)
                currentRotation = accumulatedRotation
            }
            onPressed: (mouse) =>{
                lastMousePos = Qt.point(mouse.x, mouse.y)
                isFirstMove = true  // 每次重新开始拖动时重置
            }
            onPositionChanged: (mouse) => {
                var rotDir = calculateRotationDirection(mouse.x, mouse.y)
                updateCameraRotation(rotDir.x, rotDir.y)
                updateCameraPosition()
                lastMousePos = Qt.point(mouse.x, mouse.y)
            }

            // 6. 滚轮缩放
            onWheel: (wheel) => {
                         currentDistance = Math.max(0.1, currentDistance - wheel.angleDelta.y * 0.01)
                         updateCameraPosition()
                     }

            // 7. 初始化（组件加载完成后定位相机）
            Component.onCompleted: updateCameraPosition()

            // ▶▶ 以下是老板提供的四元数运算函数（必须放在最后）◀▶
            function angleAxisToQuat(angle, axis) {
                var a = angle * Math.PI / 180.0;
                var s = Math.sin(a * 0.5);
                var c = Math.cos(a * 0.5);
                return Qt.quaternion(c, axis.x * s, axis.y * s, axis.z * s);
            }

            function multiplyQuaternion(q1, q2) {
                return Qt.quaternion(
                            q1.scalar * q2.scalar - q1.x * q2.x - q1.y * q2.y - q1.z * q2.z,
                            q1.scalar * q2.x + q1.x * q2.scalar + q1.y * q2.z - q1.z * q2.y,
                            q1.scalar * q2.y + q1.y * q2.scalar + q1.z * q2.x - q1.x * q2.z,
                            q1.scalar * q2.z + q1.z * q2.scalar + q1.x * q2.y - q1.y * q2.x
                            );
            }

            // 修正的向量旋转方法（替代rotatedVector）
            function rotateVector(q, v) {
                // 四元数旋转向量公式: v' = q * v * q^-1
                var qv = Qt.quaternion(0, v.x, v.y, v.z)
                var qConj = Qt.quaternion(q.scalar, -q.x, -q.y, -q.z)
                var rotated = multiplyQuaternion(q, multiplyQuaternion(qv, qConj))
                return Qt.vector3d(rotated.x, rotated.y, rotated.z)
            }

            // 分离位置计算逻辑
            function updateCameraPosition() {
                var forward = rotateVector(currentRotation, Qt.vector3d(0, 0, -1))
                var newPos = targetPosition.minus(forward.times(currentDistance))

                model.camera_node_translation.x = newPos.x
                model.camera_node_translation.y = newPos.y
                model.camera_node_translation.z = newPos.z
                model.camera_node_rotation.rotation = currentRotation
            }
        }
    }
    Row{
        Slider{
            id:lx
            from: 0
            to:1
            value: 0
        }
        Slider{
            id:ly
            from: 0
            to:1
            value: 0
        }
        Slider{
            id:lz
            from: 0
            to:1
            value: 0
        }
    }
}
