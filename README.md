# PSM
- Author: wyq<<771806310@qq.com>>
- This project is written on Matlab based on the polar scan matching algorithm(https://github.com/wyq0721/PSM/blob/master/images/image-output.jpg)
- Example( in test.m)
- Input 
  - dataset: 'seattle.mat'
  - step: 12451
  - interval: 6
  - orient_termination: 0.1\[deg]
  - translate_termination: 0.005\[m]
- Output
  - Figure
    ![image-output]( https://github.com/wyq0721/ROS-GET/blob/master/images/catkin-compile.png     )
  - Display in Command Window
    ```
    BREAK: In PSM 7 Iter, Delta_Translation 0.002700 and Delta_Orientation 0.000246 is Smaller Than Threshold.
        Transmation Matrix
        0.9849    0.1734    0.0743
       -0.1734    0.9849   -0.0400
             0         0    1.0000

        psm_time  psm_error
        0.0217    0.0117
    ```