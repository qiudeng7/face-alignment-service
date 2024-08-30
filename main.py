from flask import Flask, request, jsonify, render_template
import face_alignment 
import torch
import helper

app = Flask(__name__,template_folder='web_page')

face = face_alignment.FaceAlignment(face_alignment.LandmarksType.TWO_D, flip_input=False,device='cpu',face_detector='blazeface')


@app.route('/')
def handle_get():
    return render_template('index.html')

@app.route('/api/get_landmarks', methods=['POST'])
def handle_post():
    # 从请求中获取base64图片
    base64_image =request.get_json()['image-base64']
    # 转化为张量
    tensor = helper.base64_image_to_tensor(base64_image)
    # 获取人脸关键点
    position_np = face.get_landmarks(tensor)
    
    if position_np:
        # 关键点的坐标点转化为Python二位数组
        position_2Dlist = [ [ int(x[0]) , int(x[1]) ] for x in position_np[0]]
        response = {
            'status': '识别成功',
            'position': position_2Dlist
        }
        return jsonify(response)
    else:
        return jsonify({
            'status': '识别失败'
        })

if __name__ == '__main__':
    app.run(debug=True,port=9000)
