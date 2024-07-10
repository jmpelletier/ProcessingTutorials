/**
 * このスケッチでは、カメラの映像の
 * 画像の他に、もう一つの画像を用意する。そうすると、
 * 今後、カメラの画像を加工して、その結果を出力の画像
 * の中に保管する事ができるようになる。
 */

import processing.video.*;

Capture cam; // カメラ
PImage cameraImage; // カメラの画像を保存する画像
PImage outImage; // 出力の画像

int cameraNumber = 0; // 使うカメラのインデックス（順番）

float fps = 30; // カメラのフレームレート

// プログラムの初期設定
void setup() {
  // フルスクリーン表示
  fullScreen();
  
  // アンチエイリアシングの質を設定
  smooth(2);

  // カメラの画像を保存する画像を作成する
  cameraImage = createImage(640, 480, RGB);

  // 出力の画像を作成する
  outImage = createImage(640, 480, RGB);

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

    // 以下の指示を実行しないと画像のピクセルを操作する事ができない
    cameraImage.loadPixels();
    outImage.loadPixels();

    // 二重ループを使って、取り込んだ画像のピクセルを一つずつ処理する
    for (int y = 0; y < cameraImage.height; y++) {
      for (int x = 0; x < cameraImage.width; x++) {
        // 「何番目」かのピクセルを操作するか、xとy座標から計算する
        int i = y * cameraImage.width + x;
        int j = y * cameraImage.width + x;

        // 今回は入力画像のピクセルを出力画像にコピーするだけ
        outImage.pixels[j] = cameraImage.pixels[i];
      }
    }

    // 画像のピクセルが更新されたら、最後に以下の指示を実行して、確定させる。
    outImage.updatePixels();
  }

  // 画像を表示する
  background(0); // 背景を黒塗りにする
  imageMode(CENTER); // 画像の座標を中心に合わせる
  float scale = height / outImage.height; // 画像の拡大を計算する
  // 画像を画面の中心に配置して、拡大表示する
  image(outImage, width / 2, height / 2, outImage.width * scale, outImage.height * scale);
}
