import face_alignment
from skimage import io

fa = face_alignment.FaceAlignment(face_alignment.LandmarksType.TWO_D, flip_input=False,device='cpu')

input = io.imread('face-alignment/test/assets/aflw-test.jpg')
preds = fa.get_landmarks(input)

print(preds)