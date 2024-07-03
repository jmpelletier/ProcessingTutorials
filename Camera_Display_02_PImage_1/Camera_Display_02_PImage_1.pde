/**
 * このスケッチでは、カメラの映像を取り込んだ後に、
 * 画像（PImage）にコピーしてその画像を表示する。
 * 結果は前のスケッチと全く同じだが、画像を用いる
 * ことによって、様々な処理が今後可能になる。
 */
 
import processing.video.*;

Capture cam; // カメラ
PImage cameraImage; // カメラの画像を保存する画像

int cameraNumber = 0; // 使うカメラのインデックス（順番）

float fps = 30; // カメラのフレームレート

// プログラムの初期設定
void setup() {

  // ウィンドウのサイズを設定
  size(640, 480);

  // カメラの画像を保存する画像を作成する
  cameraImage = createImage(width, height, RGB);

  // カメラのリスト（配列）を取得する
  String[] cameras = Capture.list();

  // カメラが接続されているかを確認する
  if (cameras.length == 0) {
    // 接続されていないようで、エラーを出力する
    println("There are no cameras available for capture.");
    // プログラムを修了する
    exit();
  } else { // カメラが見つかった...
  
    // 見つけたカメラの名称を出力する
    println("Available cameras:");
    for (int i = 0; i < cameras.length; i++) {
      println(cameras[i]);
    }

    // 指定したカメラのインデックスが大きすぎないかを確認する
    if (cameraNumber < cameras.length && cameraNumber >= 0) {
      // カメラを起動させる
      cam = new Capture(this, cameras[cameraNumber], fps);
      cam.start();
    } else { // カメラのインデックスが大きすぎる
      // エラーを出力して修了する
      println("Invalid index");
      exit();
    }
  }
}

// フレームの描写
void draw() {
  // カメラの準備はできているか？
  if (cam.available() == true) {
    // カメラの映像を更新する
    cam.read();
    
    // カメラの映像を画像にコピーする
    cameraImage.copy(cam, 0, 0, cam.width, cam.height, 0, 0, cam.width, cam.height);
  }
  
  // 以下の指示を実行しないと画像のピクセルを操作する事ができない
  cameraImage.loadPixels();

  // 画像を表示する
  image(cameraImage, 0, 0);
}
