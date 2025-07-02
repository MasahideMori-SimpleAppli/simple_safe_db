# simple_safe_db

(en)Japanese ver is [here](https://github.com/MasahideMori-SimpleAppli/simple_safe_db/blob/main/README_JA.md).  
(ja)この解説の日本語版は[ここ](https://github.com/MasahideMori-SimpleAppli/simple_safe_db/blob/main/README_JA.md)にあります。

## Caution
This project is under construction and will not be available until this notice is removed.  

## Overview
"SimpleSafeDB" is an in-memory database for the front-end.  
This database allows you to register class structures as they are in the database,  
and allows full-text searches of the elements of the registered classes.  
In addition, queries are also classes, and can have DB operation information consisting of   
who, when, what, why, and from.  
If serialized and saved, it provides a very rich source of information for security audits and 
usage analysis.  
This is particularly useful in projects with various constraints, such as medical use.  
In addition, for when, the TemporalTrace class has a complete tracing function for   
the communication path and each arrival time.  
I I think this would be useful, for example, in space-scale communication networks,   
where even the speed of light introduces significant delays.  

This package does not incorporate search acceleration methods such as index creation,  
and searches are performed directly on memory.  
For this reason, we currently recommend using a general database when using large-scale data or   
when search speed is required.  

## Usage
Under developing.  

## Support
As this is an experimental project for future use, there is no support.   
If you have any problems, please open an issue on Github.  

## About version control
The C part will be changed at the time of version upgrade.  
However, versions less than 1.0.0 may change the file structure regardless of the following rules.  
- Changes such as adding variables, structure change that cause problems when reading previous files.
    - C.X.X
- Adding methods, etc.
    - X.C.X
- Minor changes and bug fixes.
    - X.X.C

## License
This software is released under the Apache-2.0 License, see LICENSE file.  

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

## Copyright notice
The “Dart” name and “Flutter” name are trademarks of Google LLC.  
*The developer of this package is not Google LLC.