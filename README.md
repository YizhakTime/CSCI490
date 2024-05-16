# Language_Learner
Name: Yizhak Cohen

Username: YizhakTime

I want users to be able to use their phone to take live video of objects (road signs, bathroom signs, food) and be able to get the translation in the language of their choice. Potentially, I want to create a system so they can store translations, after taking live video, into flashcards so they can study later on. 

My project will use Yolov8 along with Google Translate API to detect images in real-time and translate them in different languages to help users develop their fluency in their target language. My goal will be to deploy and have it working on Flutter, but I am testing (as a backup) in my desktop. 

Timeline:  
(1/29) -> Installed Flutter and cmd-line tools  
(1/30) -> Build basic scaffolding for app  
(2/4) -> Added basic sign-in page  
(2/10) -> Can Signin/Signup  
(2/20)-> Can translate form text into another language  
(5/7) -> Can view camera, translate them, add photo, translate them, save to flashcards, view notecards
- Added app1 directory which has Flutter code, yolov8 directory has pretrained ultralytics yolov8 model and code for object detection
- Used Firebase Auth UI for user authentication, Firebase for backend, Flutter vision package, ultralytics model
- Only works with 80 objects via COCO dataset in Ultrlytics site
