# Learning OpenGL

# Day 1 - Initialize the OpenGL environment

1. Create a empty project in Visual Studio.
2. Set up the GLFW dependent files.
    - Download the GLFW header file, which provides graphics apis for development.While 64-bit version got a lot of problems, I chose to using the 32-bit version.You can get both versions  below:

        [GLFW - Download](https://www.glfw.org/download.html)

    - Unzip the downloaded file(glfw-XXX.zip), and move the **include** and **lib-vc20xx** folder to the root folder of project.(glfw3.dll and glfw3dll.lib files could be deleted).In this project, I put this two folders into LearnOpenGL\Dependencies\GLFW\.
    - Config the Visual Studio project property. Open the **Property Page** and set the **Configuration** to **All Configuration**.
    - Config the Include Directories. Open the Property Page > Configuration Properties > C/C++ > General > Additional Directories and add the path ($(SolutionDir)Dependencies\GLFW\include) to the **include** folder.
    - Config the Linker. First, Property Page > Configuration Properties > Linker > General > Additional Library Directories and add the path to the **lib-vc20xx** folder. Second, Linker > Input > Additional Dependencies and add the name of lib(glfw3.lib)
    - Test the environment. Copy the code from GLFW and build project. Code 's here:

    [GLFW - Documentation](https://www.glfw.org/documentation.html)

3. Set up the GLEW dependent file
    - Download the GLEW file, link 's here

        [The OpenGL Extension Wrangler Library](http://glew.sourceforge.net/)

    - Unzip the file to LearnOpenGL\Depedencies(same as GLFW)
    - Add the path to **Include** folder in C/C++ > General > Additional Directories.
    - Add the path to **glew32s.lib** file's folder to the Linker > General > Additional Library Directories.
    - Add the **glew32s.lib** to the Linker > Input > Additional Dependencies
    - Config the Preprocessor. Add the **GLEW_STATIC** to C/C++ > Preprocessor > Preprocessor Definitions.

    1. The glew header needs to be included before the other header.
    2. glewInit() function needs to be called before using any of glew functions.
    3. glewInit() function should be called after having a valid OpenGL rendering context.

# Day 2 - Draw a Triangle

1. Create a vertex array.

    ```cpp
    // create three vertexes contain two float per vertex
    	float positions[6] = {
    		-0.5f, -0.5f,
    		-0.0f,  0.5f,
    		 0.5f, -0.5f
    	};
    ```

2. Create a vertex buffer. OpenGL is similar to state machine, I set value buffer here as input, and it come out with assigned value ,which contains the id of the vertex buffer. We can access the buffer by the buffer id.

    ```cpp
    // create vertex buffer, buffer(unsigned int) is the id of buffer 
    	unsigned int buffer;
    	glGenBuffers(1, &buffer);
    	glBindBuffer(GL_ARRAY_BUFFER, buffer);
    	glBufferData(GL_ARRAY_BUFFER, 6 * sizeof(float), positions, GL_STATIC_DRAW);
    ```

3. Declare the formation of vertex. Draw function needs to know what is inside a vertex, Because a single vertex might takes lots of values as attributes. I took two float value as the location of a vertex.

    ```cpp
    // declare the formation of the vertex
    	glEnableVertexAttribArray(0);
    	glVertexAttribPointer(0, 2, GL_FLOAT, GL_FALSE, sizeof(float) * 2, 0);
    ```

4. Finish the draw call function.

    ```cpp
    while (!glfwWindowShouldClose(window))
    	{
    		/* Render here */
    		glClear(GL_COLOR_BUFFER_BIT);

    		// draw a triangle
    		glDrawArrays(GL_TRIANGLES, 0, 3);

    		/* Swap front and back buffers */
    		glfwSwapBuffers(window);

    		/* Poll for and process events */
    		glfwPollEvents();
    	}
    ```
