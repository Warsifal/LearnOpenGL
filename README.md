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

Drawing a Trangle is contains of four steps:

- Declare a vertexes array.
- Tansfer the array to a vertexes buffer.
- Tell the OpenGL the formation of a vertex.
- Draw call

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

# Day 3 Write a shader

glCreateShader() is a function to create a shader, it takes shader type as input and return a integer refer to shader. 

```cpp
GLuint glCreateShader(GLenum shaderType);
```

Then we need the glShaderSource() function replace the shader code in our shader.  The parameters of this function respectively refers to the shader's reference, number of element in the shader source code, the shader code to pass to the function, the max length of single code in the shader code.

```cpp
void glShaderSource(GLuint shader,
    GLsizei count,
    const GLchar **string,
    const GLint *length);
```

After getting a shader, we still need the glCompileShader() function to compile the shader code. 

```cpp
void glCompileShader(GLuint shader);
```

We need to know that if the shader is working properly, so we need to add a glGetShaderiv() function to access the status of the shader and glGetShaderInfoLog() to get the Error info.

```cpp
void glGetShaderiv(GLuint shader,
    GLenum pname,
    GLint *params);

void glGetShaderInfoLog(GLuint shader,
    GLsizei maxLength,
    GLsizei *length,
    GLchar *infoLog);
```

A program needs a vertex shader and a fragment shader. So we can set the compile shader code into a function CompileShader():

```cpp
static unsigned int CompileShader(unsigned int type, const std::string& source)
{
	const char* src = source.c_str();
	unsigned int id = glCreateShader(type);

	// Replaces the source code in a shader object
	glShaderSource(id, 1, &src, nullptr);
	glCompileShader(id);

	// get the status of shader
	int result;
	glGetShaderiv(id, GL_COMPILE_STATUS, &result);

	if (result == GL_FALSE)
	{
		// get the length of error info
		int length;
		glGetShaderiv(id, GL_INFO_LOG_LENGTH, &length);

		// get the error info
		char* message = new char[length];
		glGetShaderInfoLog(id, length, &length, message);

		std::cout << "Failed to compile " << (type == GL_VERTEX_SHADER ? "vertex" : "fragment") << std::endl;
		std::cout << message << std::endl;

		// undoes the effects of a call to glCreateShader
		glDeleteShader(id);
		delete[] message;

		return 0;
	}

	return id;
}
```

A program object is an object to which shader objects can be attached and it can check out the compatibility of the shaders. We can create a program by using function glCreateProgram():

```cpp
GLuint glCreateProgram(void);
```

Then we can link the shader to program by using glAttachShader():

```cpp
void glAttachShader(GLuint program, GLuint shader);
```

After that, we need to run glLinkProgram() function to create executables for different shader codes that will be run on specified processor.

```cpp
void glLinkProgram(	GLuint program);
```

And don't forget to check out executables contained in program can execute given the current OpenGL state.

```cpp
void glValidateProgram(	GLuint program);
```

For convenience, I will turn the codes before into a function CreateShader():

```cpp
static int CreateShader(const std::string& vertexShader, const std::string& fragmentShader)
{
	unsigned int program = glCreateProgram();
	unsigned int vs = CompileShader(GL_VERTEX_SHADER, vertexShader);
	unsigned int fs = CompileShader(GL_FRAGMENT_SHADER, fragmentShader);

	glAttachShader(program, vs);
	glAttachShader(program, fs);
	glLinkProgram(program);
	glValidateProgram(program);

	glDeleteShader(vs);
	glDeleteShader(fs);

	return program;
}
```

I separated the shader code from the source code to a .shader file and I added a function in source code to read the shader code from the files:

shader code:

```cpp
#shader vertex
#version 330 core

layout(location = 0) in vec4 position;		// location is refer to the first value of glVertexAttribPointer

void main()
{
	gl_Position = position;
};

#shader fragment
#version 330 core

layout(location = 0) out vec4 color;		// declare the output type: color

void main()
{
	color = vec4(1.0, 0.0, 0.0, 1.0);
};
```

ParseShader function:

```cpp
static ShaderProgramSource ParseShader(const std::string& filepath)
{
	std::ifstream stream(filepath);

	enum class ShaderType
	{
		NONE = -1,
		VERTEX = 0,
		FRAGMENT = 1
	};

	std::string line;
	std::stringstream ss[2];
	ShaderType type = ShaderType::NONE;
	while (getline(stream, line))
	{
		if (line.find("#shader") != std::string::npos)
		{
			if (line.find("vertex") != std::string::npos) {
				type = ShaderType::VERTEX;
			}
			else if (line.find("fragment") != std::string::npos) {
				type = ShaderType::FRAGMENT;
			}
		}
		else 
		{
			ss[(int)type] << line << '\n';
		}
	}

	return { ss[0].str(), ss[1].str() };
}
```

Finally, we can run the glUseProgram() function to install the program object as part of current rendering state, and the result of day 2's white triangle will turn into red one.

```cpp
void glUseProgram(	GLuint program);
```

# Day 4 Indices buffer

Indices buffer is a buffer that stores the indices of the vertexes, and reuses the vertexes. I will use a indices buffer to create a square that contains of two triangles.

Firstly, I will need a four vertexes array that makes up a square and a six indices array that make up two triangles.

```cpp
// drawing a square
// create four vertexes contain two float per vertex
float positions[] = {
	-0.5f,  0.5f,	// Upper Left
	-0.5f, -0.5f,	// Lower Left
	 0.5f, -0.5f,	// Lower Right
	 0.5f,  0.5f	// Upper Right
};

// declare which vertexes to form a triangle
unsigned int indices[] = {
	0, 1, 2,		// Triangle in Bottom Left
	2, 3, 0			// Triangle in Upper Right
};
```

Secondly, I will pass these arraies to specified buffers.

```cpp
// create a vertex buffer, buffer(unsigned int) is the id of buffer 
unsigned int buffer;
glGenBuffers(1, &buffer);
glBindBuffer(GL_ARRAY_BUFFER, buffer);
glBufferData(GL_ARRAY_BUFFER, 6 * 2 * sizeof(float), positions, GL_STATIC_DRAW);

// create a indices buffer to reuse the vertexes that forms different triangles.
unsigned int ibo;
glGenBuffers(1, &ibo);
glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, ibo);
glBufferData(GL_ELEMENT_ARRAY_BUFFER, 6 * sizeof(unsigned int), indices, GL_STATIC_DRAW);
```

Finally, I will have to change the draw call function of the previous version.

```cpp
/* Loop until the user closes the window */
while (!glfwWindowShouldClose(window))
{
	/* Render here */
	glClear(GL_COLOR_BUFFER_BIT);

	// draw call that uses vertexes buffer
	// glDrawArrays(GL_TRIANGLES, 0, 3);

	// draw call that uses indices buffer
	glDrawElements(GL_TRIANGLES, 6, GL_UNSIGNED_INT, nullptr);

/* Swap front and back buffers */
	glfwSwapBuffers(window);

	/* Poll for and process events */
	glfwPollEvents();
}
```
