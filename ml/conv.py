'''import tensorflow as tf
import tfcoreml


IMAGE_INPUT_NAME = ["input:0"]
IMAGE_INPUT_NAME_SHAPE = {'input:0':[1,224,224,3]}
IMAGE_INPUT_SCALE = 1.0/255.0
OUTPUT_NAME = ['MobilenetV2/Predictions/Reshape_1:0']
MODEL_LABELS = 'ImageNetLabels.txt'
TF_FROZEN_MODEL = '/home/diptanshu/Documents/ProvIns/ProvIns/ml/MobileNet/mobilenet_v2_1.0_224_frozen.pb'
# Output model
CORE_ML_MODEL = "mobilenet_v2_1.0_224.mlmodel"

# Convert model and save it as a file
coreml_model = tfcoreml.convert(
        tf_model_path=TF_FROZEN_MODEL,
        mlmodel_path=CORE_ML_MODEL,
        output_feature_names=OUTPUT_NAME,
        image_input_names=IMAGE_INPUT_NAME,
        input_name_shape_dict = IMAGE_INPUT_NAME_SHAPE,
        class_labels=MODEL_LABELS,
        image_scale=IMAGE_INPUT_SCALE
)'''
#Final commit
import tensorflow as tf
from tensorflow.python.tools import strip_unused_lib
from tensorflow.python.framework import dtypes
from tensorflow.python.platform import gfile

def load_saved_model(path):
    the_graph = tf.Graph()
    with tf.Session(graph=the_graph) as sess:
        tf.saved_model.loader.load(sess, 
                [tf.saved_model.tag_constants.SERVING], path)
    return the_graph

saved_model_path = "/home/diptanshu/Desktop/Humandet/ssdlite_mobilenet_v2_coco_2018_05_09/saved_model"
the_graph = load_saved_model(saved_model_path)
frozen_model_file = "/home/diptanshu/Desktop/Humandet/ssdlite_mobilenet_v2_coco_2018_05_09/frozen_inference_graph.pb"       
input_node = "Preprocessor/sub"
bbox_output_node = "concat"
class_output_node = "Postprocessor/convert_scores"

def optimize_graph(graph):
    gdef = strip_unused_lib.strip_unused(
            input_graph_def = graph.as_graph_def(),
            input_node_names = [input_node],
            output_node_names = [bbox_output_node, class_output_node],
            placeholder_type_enum = dtypes.float32.as_datatype_enum)

    with gfile.GFile(frozen_model_file, "wb") as f:
        f.write(gdef.SerializeToString())
        
optimize_graph(the_graph)
import tfcoreml

coreml_model_path = "MobileNetV2_SSDLite.mlmodel"

input_width = 300
input_height = 300

input_tensor = input_node + ":0"
bbox_output_tensor = bbox_output_node + ":0"
class_output_tensor = class_output_node + ":0"

ssd_model = tfcoreml.convert(
    tf_model_path=frozen_model_file,
    mlmodel_path=coreml_model_path,
    input_name_shape_dict={ input_tensor: [1, input_height, input_width, 3] },
    image_input_names=input_tensor,
    output_feature_names=[bbox_output_tensor, class_output_tensor],
    is_bgr=False,
    red_bias=-1.0,
    green_bias=-1.0,
    blue_bias=-1.0,
    image_scale=2./255)
spec = ssd_model.get_spec()

spec.description.input[0].name = "image"
spec.description.input[0].shortDescription = "Input image"
spec.description.output[0].name = "scores"
spec.description.output[0].shortDescription = "Predicted class scores for each bounding box"
spec.description.output[1].name = "boxes"
spec.description.output[1].shortDescription = "Predicted coordinates for each bounding box"
input_mlmodel = input_tensor.replace(":", "__").replace("/", "__")
class_output_mlmodel = class_output_tensor.replace(":", "__").replace("/", "__")
bbox_output_mlmodel = bbox_output_tensor.replace(":", "__").replace("/", "__")

for i in range(len(spec.neuralNetwork.layers)):
    if spec.neuralNetwork.layers[i].input[0] == input_mlmodel:
        spec.neuralNetwork.layers[i].input[0] = "image"
    if spec.neuralNetwork.layers[i].output[0] == class_output_mlmodel:
        spec.neuralNetwork.layers[i].output[0] = "scores"
    if spec.neuralNetwork.layers[i].output[0] == bbox_output_mlmodel:
        spec.neuralNetwork.layers[i].output[0] = "boxes"

spec.neuralNetwork.preprocessing[0].featureName = "image"        
num_classes = 90
num_anchors = 1917
spec.description.output[0].type.multiArrayType.shape.append(num_classes + 1)
spec.description.output[0].type.multiArrayType.shape.append(num_anchors)
del spec.description.output[1].type.multiArrayType.shape[-1]
import coremltools
spec = coremltools.utils.convert_neural_network_spec_weights_to_fp16(spec)
ssd_model = coremltools.models.MLModel(spec)
ssd_model.save(coreml_model_path)