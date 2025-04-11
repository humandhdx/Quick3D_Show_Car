import QtQuick
import QtQuick3D
import Qt3D.Extras
Node {
    id: rootNode
    property var camera_node_translation: cinema_4D______AssimpFbx__Translation
    property var camera_node_rotation: cinema_4D______AssimpFbx__Rotation
    Node {
        id: cinema_4D______AssimpFbx__Translation
        x: 0//3.1251
        y: 3.28061
        z: -5.69166
        Node {
            id: cinema_4D______AssimpFbx__Rotation
            //(x,y,z,w)=(-0.0493328, 0.95041, 0.205486, 0.228173)
            //转换为欧拉角（近似值）：Yaw (Y轴旋转)：~110°/ Pitch (X轴旋转)：~24°/Roll (Z轴旋转)：~10°
            //组合效果：与父节点的 PostRotation 抵消，最终相机朝向由 cinema_4D______AssimpFbx__Rotation 决定
            rotation: Qt.quaternion(0.228173, -0.0493328, 0.95041, 0.205486)
            Node {
                id: cinema_4D______AssimpFbx__PostRotation
                //rotation: Qt.quaternion(0.707107, 0, 0.707107, 0)
                PerspectiveCamera {
                    id: cinema_4D____
                    //rotation: Qt.quaternion(0.707107, 0, -0.707107, 0)和父节点的旋转相互抵消
                    //rotation.x: lx.value
                    //rotation.y: ly.value
                    //rotation.z: lz.value
                    clipNear: 0.001
                    fieldOfView: 53.1301
                    fieldOfViewOrientation: PerspectiveCamera.Horizontal
                }
            }
        }
    }
    Node {
        id: anyConv_com__su7_obj
        Model {
            id: object_0
            source: "meshes/object_0.mesh"

            DefaultMaterial {
                id: defaultMaterial_material
                diffuseColor: "#ffcccccc"
            }
            DefaultMaterial {
                id: defaultMaterial_material1
                diffuseColor: "red"
            }
            materials: [
                defaultMaterial_material
            ]
        }
        Model {
            id: object_1
            source: "meshes/object_1.mesh"
            materials: [
                defaultMaterial_material1
            ]
        }
        Model {
            id: object_2
            source: "meshes/object_2.mesh"
            materials: [
                defaultMaterial_material
            ]
        }
        Model {
            id: object_3
            source: "meshes/object_3.mesh"
            materials: [
                defaultMaterial_material
            ]
        }
        Model {
            id: object_4
            source: "meshes/object_4.mesh"
            materials: [
                defaultMaterial_material
            ]
        }
        Model {
            id: object_5
            source: "meshes/object_5.mesh"
            materials: [
                defaultMaterial_material
            ]
        }
        Model {
            id: object_6
            source: "meshes/object_6.mesh"
            materials: [
                defaultMaterial_material
            ]
        }
        Model {
            id: object_7
            source: "meshes/object_7.mesh"
            materials: [
                defaultMaterial_material
            ]
        }
        Model {
            id: object_8
            source: "meshes/object_8.mesh"
            materials: [
                defaultMaterial_material
            ]
        }
        Model {
            id: object_9
            source: "meshes/object_9.mesh"
            materials: [
                defaultMaterial_material
            ]
        }
        Model {
            id: object_10
            source: "meshes/object_10.mesh"
            materials: [
                defaultMaterial_material
            ]
        }
        Model {
            id: object_11
            source: "meshes/object_11.mesh"
            materials: [
                defaultMaterial_material
            ]
        }
        Model {
            id: object_12
            source: "meshes/object_12.mesh"
            materials: [
                defaultMaterial_material
            ]
        }
        Model {
            id: object_13
            source: "meshes/object_13.mesh"
            materials: [
                defaultMaterial_material
            ]
        }
        Model {
            id: object_14
            source: "meshes/object_14.mesh"
            materials: [
                defaultMaterial_material
            ]
        }
        Model {
            id: object_15
            source: "meshes/object_15.mesh"
            materials: [
                defaultMaterial_material
            ]
        }
        Model {
            id: object_16
            source: "meshes/object_16.mesh"
            materials: [
                defaultMaterial_material
            ]
        }
        Model {
            id: object_17
            source: "meshes/object_17.mesh"
            materials: [
                defaultMaterial_material
            ]
        }
        Model {
            id: object_18
            source: "meshes/object_18.mesh"
            materials: [
                defaultMaterial_material
            ]
        }
        Model {
            id: object_19
            source: "meshes/object_19.mesh"
            materials: [
                defaultMaterial_material
            ]
        }
        Model {
            id: object_20
            source: "meshes/object_20.mesh"
            materials: [
                defaultMaterial_material
            ]
        }
        Model {
            id: object_21
            source: "meshes/object_21.mesh"
            materials: [
                defaultMaterial_material
            ]
        }
        Model {
            id: object_22
            source: "meshes/object_22.mesh"
            materials: [
                defaultMaterial_material
            ]
        }
        Model {
            id: object_23
            source: "meshes/object_23.mesh"
            materials: [
                defaultMaterial_material
            ]
        }
        Model {
            id: object_24
            source: "meshes/object_24.mesh"
            materials: [
                defaultMaterial_material
            ]
        }
        Model {
            id: object_25
            source: "meshes/object_25.mesh"
            materials: [
                defaultMaterial_material
            ]
        }
        Model {
            id: object_26
            source: "meshes/object_26.mesh"
            materials: [
                defaultMaterial_material
            ]
        }
        Model {
            id: object_27
            source: "meshes/object_27.mesh"
            materials: [
                defaultMaterial_material
            ]
        }
        Model {
            id: object_28
            source: "meshes/object_28.mesh"
            materials: [
                defaultMaterial_material
            ]
        }
        Model {
            id: object_29
            source: "meshes/object_29.mesh"
            materials: [
                defaultMaterial_material
            ]
        }
        Model {
            id: object_30
            source: "meshes/object_30.mesh"
            materials: [
                defaultMaterial_material
            ]
        }
        Model {
            id: object_31
            source: "meshes/object_31.mesh"
            materials: [
                defaultMaterial_material
            ]
        }
        Model {
            id: object_32
            source: "meshes/object_32.mesh"
            materials: [
                defaultMaterial_material
            ]
        }
        Model {
            id: object_33
            source: "meshes/object_33.mesh"
            materials: [
                defaultMaterial_material
            ]
        }
        Model {
            id: object_34
            source: "meshes/object_34.mesh"
            materials: [
                defaultMaterial_material
            ]
        }
        Model {
            id: object_35
            source: "meshes/object_35.mesh"
            materials: [
                defaultMaterial_material
            ]
        }
        Model {
            id: object_36
            source: "meshes/object_36.mesh"
            materials: [
                defaultMaterial_material
            ]
        }
        Model {
            id: object_37
            source: "meshes/object_37.mesh"
            materials: [
                defaultMaterial_material
            ]
        }
        Model {
            id: object_38
            source: "meshes/object_38.mesh"
            materials: [
                defaultMaterial_material
            ]
        }
        Model {
            id: object_39
            source: "meshes/object_39.mesh"
            materials: [
                defaultMaterial_material
            ]
        }
        Model {
            id: object_40
            source: "meshes/object_40.mesh"
            materials: [
                defaultMaterial_material
            ]
        }
    }
}
