# Learning OpenGL

# Day 1 - Initialize the OpenGL environment

1. Download the GLFW header file, which provides graphics apis for development.

    While 64-bit version got a lot of problems, I turned to use the 32-bit version.You can get both versions  below:

    [GLFW - Download](https://www.glfw.org/download.html)

2. Create a empty project in Visual Studio.
3. Set up the dependent files.
    - Unzip the downloaded file(glfw-XXX.zip), and move the **include** and **lib-vc20xx** folder to the root folder of project.(glfw3.dll and glfw3dll.lib files could be deleted).In this project, I put this two folders into LearnOpenGL\Dependencies\GLFW\.
    - Config the Visual Studio project property. Open the **Property Page** and set the **Configuration** to **All Configuration**.
    - Config the Include Directories. Open the Property Page > Configuration Properties > C/C++ > General > Additional Directories and add the path($(SolutionDir)Dependencies\GLFW\include) to the **include** folder.
    - Config the Linker. First, Property Page > Configuration Properties > Linker > General > Additional Library Directories and add the path to the **lib-vc20xx** folder. Second, Linker > Input > Additional Dependencies and add the name of lib(glfw3.lib)
    - Test the environment. Copy the code from GLFW and build project. Code 's here:

      [GLFW - Documentation](https://www.glfw.org/documentation.html)

# Day 2 - Draw a Triangle
