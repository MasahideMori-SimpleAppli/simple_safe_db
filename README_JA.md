# simple_safe_db

## 注意
このプロジェクトは作成中です。この注意書きが消えるまでは利用できません。

## 概要
「SimpleSafeDB」は、フロントエンド用のインメモリデータベースです。  
このデータベースではクラス構造をそのままデータベースに登録でき、登録したクラスの要素を全文検索できます。  
また、クエリもクラスであり、who, when, what, why, fromで構成されるDBの操作情報を持たせられるため、
シリアライズして保存すれば、セキュリティ監査や利用状況の分析において非常にリッチな情報源を提供します。
これは特に医療用などの様々な制約のあるプロジェクトにおいて、威力を発揮します。
また、whenについては、TemporalTraceクラスによる通信経路、 及び各到達時間の完全なトレース機能を持ちます。
これは例えば、光の速度でも無視できない遅延が発生する宇宙規模の通信網などで便利ではないかと考えています。

本パッケージにはインデックス作成などの検索高速化手法は取り入れられておらず、メモリ上を直接検索します。  
このため、現時点では大規模データでの利用や検索速度が求められる場合には、一般的なデータベースの利用を推奨します。  

## 使い方
作成中です。  

## サポート
将来の利用のための実験的なプロジェクトであるため、基本的にサポートはありません。　　
もし問題がある場合はGithubのissueを開いてください。

## バージョン管理について
それぞれ、Cの部分が変更されます。  
ただし、バージョン1.0.0未満は以下のルールに関係無くファイル構造が変化する場合があります。  
- 変数の追加など、以前のファイルの読み込み時に問題が起こったり、ファイルの構造が変わるような変更
  - C.X.X
- メソッドの追加など
  - X.C.X
- 軽微な変更やバグ修正
  - X.X.C

## ライセンス
このソフトウェアはApache-2.0ライセンスの元配布されます。LICENSEファイルの内容をご覧ください。  

Copyright 2025 Masahide Mori

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.  

## 著作権表示
The “Dart” name and “Flutter” name are trademarks of Google LLC.  
*The developer of this package is not Google LLC.