一键重建脚本(部署完后 用 域名/UUID 访问 )
```bash 
curl -Ls https://raw.githubusercontent.com/townzz/node-ws/main/deploy.sh > deploy.sh && chmod +x deploy.sh && ./deploy.sh  
```
流程参考:
#1. 注册,[注册Webhostmost](https://www.webhostmost.com/free-web-hosting)
总共有6个区可以选择，选美国或者芬兰

<img width="1920" height="869" alt="开始注册Snipaste_2025-10-27_06-48-00" src="https://github.com/user-attachments/assets/20b151ea-28a3-4959-9cf2-495a0f0ff75d" />
<img width="1885" height="1006" alt="注册2Snipaste_2025-10-27_06-49-14" src="https://github.com/user-attachments/assets/d1ea743f-3868-4fd7-8330-245bd5a96c0d" />
<img width="1920" height="949" alt="注册3Snipaste_2025-10-27_06-50-10" src="https://github.com/user-attachments/assets/58a39d71-e3cf-4c16-b19d-ac5df9824a16" />

[美国地址生成信息](https://www.meiguodizhi.com)
<img width="1844" height="980" alt="注册4Snipaste_2025-10-27_06-52-02" src="https://github.com/user-attachments/assets/c27b5d02-9e2e-4069-82b9-5a92d2009cbc" />
<img width="1920" height="962" alt="注册5Snipaste_2025-10-27_06-55-15" src="https://github.com/user-attachments/assets/c6b8a159-81d0-4c8e-925d-e357c7131d19" />
<img width="1859" height="957" alt="注册6Snipaste_2025-10-27_06-56-16" src="https://github.com/user-attachments/assets/72a09adb-e3f5-4237-b2d5-be1f26de3047" />
<img width="1864" height="961" alt="注册7Snipaste_2025-10-27_06-57-42" src="https://github.com/user-attachments/assets/a56357c6-6663-43cb-8167-4981c8d0c0d3" />
<img width="1917" height="956" alt="注册8Snipaste_2025-10-27_06-58-49" src="https://github.com/user-attachments/assets/06c42996-46fa-42e1-a276-248a77a7acbd" />
点那个修改密码，修改为你的webhost登陆密码就行，方便操作
<img width="1893" height="912" alt="注册8Snipaste_2025-10-27_07-01-19" src="https://github.com/user-attachments/assets/ba8debf9-1569-42de-9274-092c2410459f" />
<img width="1920" height="1001" alt="注册9Snipaste_2025-10-27_07-03-18" src="https://github.com/user-attachments/assets/094be2d8-08c9-4611-9431-e19b2b97435d" />
<img width="1893" height="964" alt="注册10Snipaste_2025-10-27_07-04-52" src="https://github.com/user-attachments/assets/d0ebcf36-bc1f-4df1-a039-929e4aafcd7a" />
<img width="1905" height="966" alt="修改域名Snipaste_2025-10-27_07-06-08" src="https://github.com/user-attachments/assets/b6849d21-ebb2-4e59-9662-4abd361f038b" />
去解析CF记录，我推荐使用dpdns.org域名
<img width="1913" height="975" alt="解析CF记录Snipaste_2025-10-27_07-29-12" src="https://github.com/user-attachments/assets/f5b6fef4-bcf4-4082-8aac-90ef39bec477" />
<img width="1920" height="960" alt="填上解析好的域名Snipaste_2025-10-27_07-47-09" src="https://github.com/user-attachments/assets/032dc70e-be95-4be6-be92-ffa04b3e6fad" />
用webssh或者你本地的SSH连接工具登陆SSH终端，这里我推荐使用mobaxterm（非常不建议在官方面板里面的SSH终端进行操作，会被记录日志，我的脚本也就被标记完犊子了）
<img width="1900" height="953" alt="SSH登陆推荐" src="https://github.com/user-attachments/assets/0fbb0a45-8aa2-414d-b84e-449bb303c38c" />
切换到该文件夹下，(该目录下有执行权限)，每个人目录不同，自己按照实际情况来    /home/$USERNAME/domains/$DOMAIN/public_html
<img width="1904" height="943" alt="切换路径小技巧Snipaste_2025-10-27_07-32-09" src="https://github.com/user-attachments/assets/930b6ec7-c0c4-47d1-a243-1d788e79de88" />
```bash 
curl -Ls https://raw.githubusercontent.com/TownMarshal/node-ws/main/deploy.sh > deploy.sh && chmod +x deploy.sh && ./deploy.sh  
```
<img width="1920" height="869" alt="执行代码Snipaste_2025-10-27_07-21-31" src="https://github.com/user-attachments/assets/2aa39409-eabd-4466-8c47-d10894bb32a2" />
<img width="1885" height="946" alt="域名UUID记住了Snipaste_2025-10-27_07-33-27" src="https://github.com/user-attachments/assets/24eac44e-7491-408c-b411-bbbbe16213fe" />
<img width="1920" height="1027" alt="节点信息Snipaste_2025-10-27_07-35-05" src="https://github.com/user-attachments/assets/b7502196-fd64-4cb8-9ded-b27626131d35" />

开源协议说明（基于GPL）
本项目遵循 GNU 通用公共许可证（GNU General Public License, 简称 GPL）发布，并附加以下说明：

你可以自由地使用、复制、修改和分发本项目的源代码，前提是你必须保留原作者的信息及本协议内容；
修改后的版本也必须以相同协议开源；
未经原作者明确授权，不得将本项目或其任何部分用于商业用途。
商业用途包括但不限于：

将本项目嵌入到出售的软件、系统或服务中；
通过本项目直接或间接获利（例如通过广告、SaaS服务等）；
在公司或组织内部作为商业工具使用。
如需获得商业授权，请联系原作者：[admin@eooce.com]

版权所有 ©2025 eooce










