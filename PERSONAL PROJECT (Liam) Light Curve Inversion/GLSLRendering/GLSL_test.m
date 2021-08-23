CleanSlate

% Is the script running in OpenGL Psychtoolbox?
AssertOpenGL;

% Find the screen to use for display:
screenid=max(Screen('Screens'));

% Disable Synctests for this simple demo:
Screen('Preference','SkipSyncTests',1);

% Setup Psychtoolbox for OpenGL 3D rendering support and initialize the
% mogl OpenGL for Matlab wrapper:
InitializeMatlabOpenGL(1);

% Open a double-buffered full-screen window on the main displays screen.
[win , winRect] = Screen('OpenWindow', screenid, [], [0 0 500 500]);

% Make sure we run on a GLSL capable system. Abort if not.
AssertGLSL;

% Setup the OpenGL rendering context of the onscreen window for use by
% OpenGL wrapper. After this command, all following OpenGL commands will
% draw into the onscreen window 'win':
Screen('BeginOpenGL', win);

% Get the aspect ratio of the screen:
ar=winRect(4)/winRect(3);

% Turn on OpenGL local lighting model: The lighting model supported by
% OpenGL is a local Phong model with Gouraud shading.
glEnable(GL_LIGHTING);
glEnable(GL_NORMALIZE);

% Enable the first local light source GL_LIGHT_0. Each OpenGL
% implementation is guaranteed to support at least 8 light sources. 
glEnable(GL_LIGHT0);
glEnable(GL_LIGHT1);

% Enable two-sided lighting - Back sides of polygons are lit as well.
glLightModelfv(GL_LIGHT_MODEL_LOCAL_VIEWER, GL_TRUE);

% Enable proper occlusion handling via depth tests:
glEnable(GL_DEPTH_TEST);

% Define the cubes light reflection properties by setting up reflection
% coefficients for ambient, diffuse and specular reflection:
glMaterialfv(GL_FRONT_AND_BACK,GL_AMBIENT, [ 0.88 0.1 0.88 1 ]);
glMaterialfv(GL_FRONT_AND_BACK,GL_DIFFUSE, [ .22 .27 .9 1 ]);
glMaterialfv(GL_FRONT_AND_BACK,GL_SPECULAR, [ 1 1 1 1 ]);
glMaterialfv(GL_FRONT_AND_BACK,GL_SHININESS, 2);

% Set projection matrix: This defines a perspective projection,
% corresponding to the model of a pin-hole camera - which is a good
% approximation of the human eye and of standard real world cameras --
% well, the best aproximation one can do with 3 lines of code ;-)
glMatrixMode(GL_PROJECTION);
glLoadIdentity;

% Field of view is +/- 25 degrees from line of sight. Objects close than
% 0.1 distance units or farther away than 100 distance units get clipped
% away, aspect ratio is adapted to the monitors aspect ratio:
gluPerspective(100,1/ar,0.1,1000);

% Setup modelview matrix: This defines the position, orientation and
% looking direction of the virtual camera:
glMatrixMode(GL_MODELVIEW);
glLoadIdentity;

% Cam is located at 3D position (0,0,10), points upright (0,1,0) and fixates
% at the origin (0,0,0) of the worlds coordinate system:
gluLookAt(0,0,10,0,0,0,0,1,0);

% Setup position and emission properties of the light source:

% Set background color to 'black':
glClearColor(0,0,0,0);

% Point lightsource at (1,2,3)...
glLightfv(GL_LIGHT0,GL_POSITION,[ 20 200 20 0 ]);
% Emits white (1,1,1,1) diffuse light:
glLightfv(GL_LIGHT0,GL_DIFFUSE, [ 0.4 0.4 0.9 1 ]);
% Emits reddish (1,1,1,1) specular light:
% glLightfv(GL_LIGHT0,GL_SPECULAR, [ 1 1 1 1 ]);
% There's also some blue, but weak (R,G,B) = (0.1, 0.1, 0.1)
% ambient light present:
% glLightfv(GL_LIGHT0,GL_AMBIENT, [ .0 .0 .9 1 ]);

% % Point lightsource at (1,2,3)...
% glLightfv(GL_LIGHT1,GL_POSITION,[ 20 -200 20 0 ]);
% % Emits white (1,1,1,1) diffuse light:
% glLightfv(GL_LIGHT1,GL_DIFFUSE, [ 0.8 0.8 0.2 1 ]);
% % Emits reddish (1,1,1,1) specular light:
% glLightfv(GL_LIGHT1,GL_SPECULAR, [ 1 1 1 1 ]);
% % There's also some blue, but weak (R,G,B) = (0.1, 0.1, 0.1)
% % ambient light present:
% glLightfv(GL_LIGHT1,GL_AMBIENT, [ .0 .0 .9 1 ]);

glEnable(GL_NORMALIZE);

% GLSL setup:
glGetError;

% Load all pairs of GLSL shaders from the directory of demo shaders and
% create GLSL programs for them: LoadGLSLProgramFromFiles is a convenience
% function. It loads single shaders or multiple shaders from text files,
% compiles and links them into a GLSL program, checks for errors and - if
% everything is fine - returns a handle that can be used to enable the
% GLSL program via glUseProgram():
shaderpath = [PsychtoolboxRoot '/PsychDemos/OpenGL4MatlabDemos/GLSLDemoShaders/'];
% glsl(1)=LoadGLSLProgramFromFiles([shaderpath 'Flattenshader'],1);
% glsl(2)=LoadGLSLProgramFromFiles([shaderpath 'Pointlightshader'],1);
glsl(1)=LoadGLSLProgramFromFiles([shaderpath 'Pointlightshader'],1);
% glsl(4)=LoadGLSLProgramFromFiles([shaderpath 'Brickshader'],1);

gluErrorString

% Activate program:
glUseProgram(glsl(1));
programid = glsl(1);
programmax = length(glsl);
gluErrorString

objFile = 'deer_triangulated.obj';
objClassification = 'Testing Models';
[m, C, I] = SolveMassProperties(objClassification, objFile);

obj = LoadOBJFile(which(objFile));

obj{1}.vertices(1, :) = obj{1}.vertices(1, :) - C(1);
obj{1}.vertices(2, :) = obj{1}.vertices(2, :) - C(2);
obj{1}.vertices(3, :) = obj{1}.vertices(3, :) - C(3);

objmeshid = moglmorpher('addMesh', obj{1}.faces, obj{1}.vertices, [], obj{1}.normals);

times = struct('start', 0.0, 'step', 0.1, 'stop', 0.1);
massProp = struct('m', m, 'C', C, 'I', I);

% w0 = zeros(numSamples, 3);
w0 = sphereSampling(50);
numSamples = length(w0(:, 1));

w1 = zeros(3, numSamples, 2);
t1 = zeros(numSamples, 2);
q1 = zeros(4, numSamples, 2);

for i = 1:numSamples
    [t1(i, :), q1(:, i, :), w1(:, i, :)] = IntegrateEuler(massProp, w0(i, :), times, @(t, massProp) [0, 0, 0]);
end

az = 0;
el = 0;
rad = 200;

% Animation loop: Run until key press...
time_index = 0;
BRDF = zeros(numel(q1) / 8 + 1, 1);

while time_index < length(BRDF) + 1
    time_index = time_index + 1;
    fprintf("Generating frame %d / %d\n", time_index, length(BRDF))
    
    [xx, yy, zz] = sph2cart(az, el, rad);

    % Setup cubes rotation around axis:
    glPushMatrix;    
    
    gluLookAt(xx, yy, zz, 0, 0, 0, 0, 0, 1);
    
    % Calculate rotation angle for next frame:
    if time_index == 1
        current_quat = q1(:, 1, 1);
    elseif time_index <= length(BRDF)
        current_quat = q1(:, time_index - 1, 2);
    else
        current_quat = q1(:, numSamples, 2);
    end
    
    [angle, axis] = AngleAxis(quaternion(current_quat));
    
    glRotated(angle * 180 / pi, axis(1), axis(2), axis(3));
    
    % Clear out the backbuffer: This also cleans the depth-buffer for
    % proper occlusion handling:
    glClear;

    moglmorpher('renderMesh', objmeshid);

    glPopMatrix;
    
    % Finish OpenGL rendering into PTB window and check for OpenGL errors.
    Screen('EndOpenGL', win);
    
    screenImage = Screen('GetImage', win);
    
    if time_index > 1
        BRDF(time_index - 1) = getBrightnessOfImage(screenImage);
    end

    % Show rendered image at next vertical retrace:
    Screen('Flip', win);

    % Switch to OpenGL rendering again for drawing of next frame:
    Screen('BeginOpenGL', win);
    
    [keydown, secs, keycode] = KbCheck;
    if keydown
        if keycode(KbName('ESCAPE'))
            break
        elseif keycode(KbName('LeftArrow'))
            az = az + 0.1;
        elseif keycode(KbName('RightArrow'))
            el = el + 0.1;
        elseif keycode(KbName('UpArrow'))
            rad = rad + 10;
        elseif keycode(KbName('DownArrow'))
            rad = rad - 10;
        end
    end
end

% Shut down OpenGL rendering:
Screen('EndOpenGL', win);

% Reset moglmorpher:
moglmorpher('reset');

% Close onscreen window and release all other ressources:
sca;

% Reenable Synctests after this simple demo:
Screen('Preference','SkipSyncTests',1);

% Post-Processing
BRDFDiff = BRDF(2:numSamples + 1) - BRDF(1);
BRDFSign = sign(BRDFDiff) / 2 + 0.5;
BRDFColor = [0 0 1] .* BRDFSign + [1 0 0] .* (1 - BRDFSign);
w0_lower = w0(boolean(BRDFSign), :);

figure
scatter(1:length(BRDF)-1, BRDF(2:numSamples + 1), [], BRDFColor, 'filled')
hold on
plot(1:length(BRDF)-1, repmat(BRDF(1), 1, numSamples))

figure
[X, Y] = meshgrid(w0_lower(:, 1), w0_lower(:, 2));
Z = sqrt(1 - (X .^ 2 + Y .^ 2));

scatter3(w0(:, 1), w0(:, 2), w0(:, 3), [], BRDFColor, 'filled')
hold on
surf(X, Y, Z)