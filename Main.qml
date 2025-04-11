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
            property vector3d targetPosition: Qt.vector3d(0, 0.4, 0)
            property real initialDistance: targetPosition.minus(Qt.vector3d(0, 0, -7)).length()
            property quaternion initialRotation: Qt.quaternion(1, 0, 0, 0)//Qt.quaternion(0.228173, -0.0493328, 0.95041, 0.205486)

            // 2. 运行时状态
            property real currentDistance: initialDistance
            property quaternion currentRotation: initialRotation
            property point lastMousePos: Qt.point(0, 0)

            // 新增视角限制参数（单位：角度）
            property real minPitch: -0 // 最低能看到前保险杠下缘
            property real maxPitch: 45   // 最高能看到车顶
            property real currentPitch: 0 // 当前俯仰角
            
            // 改进的方向控制系统
            property vector3d upVector: Qt.vector3d(0, 1, 0)
            property vector3d rightVector: Qt.vector3d(1, 0, 0)
            
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

            // 改进的相机更新方法
            function updateCameraRotation(dx, dy) {
                // 限制俯仰角
                var newPitch = currentPitch + dy
                if (newPitch >= minPitch && newPitch <= maxPitch) {
                    currentPitch = newPitch
                    var pitchRot = angleAxisToQuat(-dy, rightVector)
                    currentRotation = multiplyQuaternion(pitchRot, currentRotation)
                }
                
                // 应用水平旋转
                var yawRot = angleAxisToQuat(dx, upVector)
                currentRotation = multiplyQuaternion(yawRot, currentRotation)
                
                // 保持相机朝向稳定
                var forward = rotateVector(currentRotation, Qt.vector3d(0, 0, -1))
                rightVector = forward.crossProduct(upVector).normalized()
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
