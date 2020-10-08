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