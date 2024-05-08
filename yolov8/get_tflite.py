from ultralytics import YOLO
import subprocess

old_file = "yolov8n_float32.tflite"
new_file = "yolov8n.tflite"
my_args = ["mv", old_file, new_file]
cwd = "yolov8n_saved_model"
model = YOLO("yolov8n.pt")
model.export(format='tflite')
subprocess.Popen(my_args, cwd='yolov8n_saved_model')

#results = model(source=0, show=True, conf=0.4,  save=True)
#shows detection on camera 
