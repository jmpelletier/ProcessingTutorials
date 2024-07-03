/**
 * このスケッチでは、入力と出力の座標を別々に
 * 計算することによって、表示を反転させる。
 */

import processing.video.*;

Capture cam; // カメラ
PImage[] imageBuffer; // カメラの画像を保存する画像
PImage outImage; // 出力の画像

int cameraNumber = 0; // 使うカメラのインデックス（順番）

float fps = 30; // カメラのフレームレート

int bufferSize = 30; // バッファーの大きさ

int writeIndex = 0; // 記憶するフレームのインデックス
int readIndex = 1; // 思い出すフレームのインデックス

// プログラムの初期設定
void setup() {

  // ウィンドウのサイズを設定
  size(640, 480);

  // フレームレートを指定
  frameRate(30);

  // カメラの画像を保存する画像を作成する
  imageBuffer = new PImage[bufferSize];
  for (int i = 0; i < imageBuffer.length; i++) {
    imageBuffer[i] = createImage(width, height, RGB);
  }

  // 出力の画像を作成する
  outImage = createImage(width, height, RGB);

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
    imageBuffer[writeIndex].copy(cam, 0, 0, cam.width, cam.height, 0, 0, cam.width, cam.height);

    PImage cameraImage = imageBuffer[readIndex];

    // 以下の指示を実行しないと画像のピクセルを操作する事ができない
    cameraImage.loadPixels();
    outImage.loadPixels();

    // 二重ループを使って、取り込んだ画像のピクセルを一つずつ処理する
    for (int y = 0; y < cameraImage.height; y++) {
      for (int x = 0; x < cameraImage.width; x++) {
        // 「何番目」かのピクセルを操作するか、xとy座標から計算する
        int i = y * cameraImage.width + x;
        int j = y * cameraImage.width + x;

        // 入力画像のピクセルを出力画像にコピーする
        outImage.pixels[j] = cameraImage.pixels[i];
      }
    }

    // 画像のピクセルが更新されたら、最後に以下の指示を実行して、確定させる。
    outImage.updatePixels();

    // バッファーのインデックスを更新
    readIndex = (readIndex + 1) % bufferSize;
    writeIndex = (writeIndex + 1) % bufferSize;
  }

  // 画像を表示する
  image(outImage, 0, 0);
}
