# San Francisco World: Leveraging Structural Regularities for 3-DoF Visual Compass
This package provides a MATLAB implementation of the RA-L 2024 paper: "San Francisco World: Leveraging Structural Regularities for 3-DoF Visual Compass" for the purpose of research and study only.

![SF-World](https://github.com/jungilha/SF-World-master/blob/main/pipeline.png)


# 1. Goal
Our goal is to estimate 3-DoF camera rotation with respect to indoor structured environments with slopes.
The proposed method exploits line and plane primitives jointly to recognize the spatial regularities of orthogonal structured environments and the uniform inclination of slopes.
Lines from RGB images and surface normals from depth images are simultaneously used to perceive environmental regularities accurately and stably.
Our method finds the optimal sloping parameter and tracks drift-free rotational motion while at least a single plane and line parallel to the San Francisco world (SFW) axes are visible. 

![SF-World](https://github.com/jungilha/SF-World-master/blob/main/result.png)


# 2. Prerequisites
This package is tested on the MATLAB R2023b on Windows 11 64-bit.


# 3. Usage
* Run SFworld_core/main_script_STSC_ARkit.m, which will give you the SFW detection and the 3D motion estimation result. Enjoy! :)
# 4. SFW Datasets
|     Sequence      | Total Traveling Rotation |  Download  |
|-------------------|--------------------------|------------|
| Half-Turn (1)     |           360°           | [[link](https://drive.google.com/file/d/1a0MrvL0GwLVSftaS2v9_ocjYTKf-DFSg/view?usp=sharing)](#)  |
| Half-Turn (2)     |           360°           | [[link](https://drive.google.com/file/d/1JVf-ALRn5_CHngKRNmc7931_l57K1mur/view?usp=sharing)](#)  |
| Quarter-Turn (1)  |           180°           | [[link](https://drive.google.com/file/d/1b7GDMLK9IKkb-8V0MTJmh5wYjgLdAcw2/view?usp=sharing)](#)  |
| Quarter-Turn (2)  |           360°           | [[link](https://drive.google.com/file/d/1No39j8VHrOxNVeevmKWyt8SBCz0kWJhy/view?usp=sharing)](#)  |
| In-Place Rotation |           1800°          | [[link](https://drive.google.com/file/d/1B4ycDQaqHyo9swFElklbNBIcHVURM_zv/view?usp=sharing)](#)  |


# 5. Publications
The approach is described and used in the following publications:

* **San Francisco World: Leveraging Structural Regularities for 3-DoF Visual Compass** (Jungil Ham, Minji Kim, Suyoung Kang, Kyungdon Joo, Haoang Li, and Pyojin Kim), RA-L 2024.

# 6. License
The package is licensed under the MIT License, see http://opensource.org/licenses/MIT.

      author = {Jungil Ham, Minji Kim, Suyoung Kang, Kyungdon Joo, Haoang Li, and Pyojin Kim},
      title = {San Francisco World: Leveraging Structural Regularities for 3-DoF Visual Compass},
      year = {2024},
      booktitle = {IEEE Robotics and Automation Letters (RA-L)},
     }
