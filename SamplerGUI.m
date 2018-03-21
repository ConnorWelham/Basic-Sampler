function varargout = SamplerGUI(varargin)
% SAMPLERGUI MATLAB code for SamplerGUI.fig
%      SAMPLERGUI, by itself, creates a new SAMPLERGUI or raises the existing
%      singleton*.
%
%      H = SAMPLERGUI returns the handle to a new SAMPLERGUI or the handle to
%      the existing singleton*.
%
%      SAMPLERGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SAMPLERGUI.M with the given input arguments.
%
%      SAMPLERGUI('Property','Value',...) creates a new SAMPLERGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before SamplerGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to SamplerGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help SamplerGUI

% Last Modified by GUIDE v2.5 17-May-2017 15:21:33

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @SamplerGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @SamplerGUI_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before SamplerGUI is made visible.
function SamplerGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to SamplerGUI (see VARARGIN)

clc

%set all variables that need to be off, effects bus and audio chop
set(handles.Aplydly,'enable','off');
set(handles.Leveledit,'enable','off');
set(handles.edtDlyTime,'enable','off');
set(handles.dstrtgaintxt,'enable','off');
set(handles.dstrtmixtxt,'enable','off');
set(handles.applydstrt,'enable','off');
set(handles.Modtxt,'enable','off');
set(handles.fctxt,'enable','off');
set(handles.aplytrem,'enable','off');

set(handles.DelayFx,'enable','off');
set(handles.trembtn,'enable','off');
set(handles.Dstrtbtn,'enable','off');

set(handles.strtT,'enable','off');
set(handles.endT,'enable','off');
set(handles.Playchop,'enable','off');

efct = 0; %effects bus is set to off straight away
setappdata(0,'efct',efct);

value = 0; %chop audio variable is set to off straight away
setappdata(0,'value',value);


pausefnc = 0; 
setappdata(0,'pausefnc',pausefnc);

pausefncfx = 0;
setappdata(0,'pausefncfx',pausefncfx);
%pause for both the original and effects player are both set to zero
%straight away

format = '.wav'; %setting the format initially allows the user to save file
%without changing the dropdown box at all
setappdata(0,'format',format);


% Choose default command line output for SamplerGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes SamplerGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = SamplerGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in loadbtn.
function loadbtn_Callback(hObject, eventdata, handles)
variable = uiimport;

fs = getfield(variable, 'fs'); %find the variable named fs and "get" it 
fsorig = fs; %use this to allow fs to be re-defined later 
data = getfield(variable, 'data'); %find the variable names data in audio file and get it.
y = data; %set y to data to allow later functions to work
setappdata(0,'y',y);
setappdata(0,'data',data);
axes(handles.axes3);
N = size(data)-1; 
t = N/fs;
x=0:1/fs:t; %time array to plot the sample against 

setappdata(0,'fs',fs)
setappdata(0,'fsorig',fsorig);
setappdata(0,'data',data)

player = audioplayer(data,fs); %define this now to allow the play/resume feature to work properly
setappdata(0,'player',player);

plot(x,data);

set(handles.efctcheck,'value',0.0);
set(handles.chopaud,'value',0.0);
efct = 0; %effects bus is set to off straight away
setappdata(0,'efct',efct);

value = 0; %chop audio variable is set to off straight away
setappdata(0,'value',value);

set(handles.Aplydly,'enable','off'); %this is to reset all variables if a 
%new file is imported
set(handles.Leveledit,'enable','off');
set(handles.edtDlyTime,'enable','off');
set(handles.dstrtgaintxt,'enable','off');
set(handles.dstrtmixtxt,'enable','off');
set(handles.applydstrt,'enable','off');
set(handles.Modtxt,'enable','off');
set(handles.fctxt,'enable','off');
set(handles.aplytrem,'enable','off');

set(handles.DelayFx,'enable','off');
set(handles.trembtn,'enable','off');
set(handles.Dstrtbtn,'enable','off');

set(handles.strtT,'enable','off');
set(handles.endT,'enable','off');
set(handles.Playchop,'enable','off');


axes(handles.axes4);
plot(x,data); %plot in both axes to allow new samples to be imported and show the new sample


% hObject    handle to loadbtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




function strtT_Callback(hObject, eventdata, handles)
% hObject    handle to strtT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of strtT as text
%        str2double(get(hObject,'String')) returns contents of strtT as a double

sT = str2double(get(handles.strtT,'String'));  %This tells the graph where to start the plot/where the sample starts
setappdata(0,'sT',sT);

eT = getappdata(0,'eT'); %end time variable
data = getappdata(0,'data');
fs = getappdata(0,'fs');

if sT == 0
    sT = sT + 0.1; %if the value is 0, it causes an error. this allows the sample to start 0.1 samples later
    
end


strtT = round(sT*fs);%Turning it into seconds of the file, rounding to make it a whole number (for delay func)


endT = eT*fs; %turning end time into seconds using sampling freq 

y = data(:,1); %select a single column of data


setappdata(0,'y',y)



y = y(floor(strtT):endT); %make a new variable using a selection of the y array from the start time to end time



setappdata(0,'y',y);

N = size(y)-1; 
t = N/fs;
x=0:1/fs:t;


axes(handles.axes4); %define the axes to plot against

plot(x,y);





% --- Executes during object creation, after setting all properties.
function strtT_CreateFcn(hObject, eventdata, handles)
% hObject    handle to strtT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end





function endT_Callback(hObject, eventdata, handles)
% hObject    handle to endT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of endT as text
%        str2double(get(hObject,'String')) returns contents of endT as a double


eT = str2double(get(handles.endT,'String')); %This tells the graph/sound where to end
setappdata(0,'eT',eT);


sT = getappdata(0,'sT'); %collect start time data
data = getappdata(0,'data');
fs = getappdata(0,'fs');

if sT == 0
    sT = sT + 0.1; %if the value is 0, it causes an error. this allows the sample to start 0.1 samples later
    
end

strtT = sT*fs; %Turning it into seconds of the file
endT = eT*fs; %Turning it into seconds of the file

setappdata(0,'strtT',strtT);
setappdata(0,'endT',endT);

y = data(:,1);


y = y(floor(strtT):endT); %make a new variable using a selection of the y array from the start time to end time

setappdata(0,'y',y);

N = size(y)-1; 
t = N/fs;
x=0:1/fs:t;

axes(handles.axes4); %define axes to plot against

plot(x,y); %plotting the data set against the time domain






% --- Executes during object creation, after setting all properties.
function endT_CreateFcn(hObject, eventdata, handles)
% hObject    handle to endT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');   
end



% --- Executes on button press in efctcheck.
function efctcheck_Callback(hObject, eventdata, handles)
% hObject    handle to efctcheck (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of efctcheck

efct = get(handles.efctcheck,'Value'); %allows the code to define the effects being either off or on
setappdata(0,'efct',efct);

if efct == 1

set(handles.DelayFx,'enable','on');
set(handles.trembtn,'enable','on');
set(handles.Dstrtbtn,'enable','on');

else  %if effect check box is unticked, then a new plot is made to show the wave form without the effects, all the
    %handles are turned off too
    
y= getappdata(0,'y');
fs = getappdata(0,'fs');
N = size(y)-1; 
t = N/fs;
x=0:1/fs:t;
axes(handles.axes4);
plot(x,y);

player = audioplayer(y,fs);
setappdata(0,'player',player);
set(handles.DelayFx,'enable','off');
set(handles.trembtn,'enable','off');
set(handles.Dstrtbtn,'enable','off');
end


% --- Executes on button press in Playchop.
function Playchop_Callback(hObject, eventdata, handles)
% hObject    handle to Playchop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

fs = getappdata(0,'fs');
y = getappdata(0,'y');
sound(y,fs); %get current (chopped) data and play it





% --- Executes on button press in playorig.
function playorig_Callback(hObject, eventdata, handles)
% hObject    handle to playorig (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

pausefnc = getappdata(0,'pausefnc');

if (pausefnc == 0) %pausefnc is used to either resume or play the player
    

player = getappdata(0,'player');
play(player);
'play'

elseif (pausefnc == 1)
    
    player = getappdata(0,'player');
    resume(player);
    pausefnc = 0; %if resume is used then set pause to 0, therefore if the user presses play again, the sample
    %will start from the beginning
'resume'
%'resume' and 'play' used to test if the code had run through correctly
end



setappdata(0,'pausefnc',pausefnc);



% --- Executes on button press in Pausebtn.
function Pausebtn_Callback(hObject, eventdata, handles)
% hObject    handle to Pausebtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

player = getappdata(0,'player');


pause(player);


pausefnc = get(handles.Pausebtn,'Value'); %this defines the pause button function, where the value will be 1 now
setappdata(0,'pausefnc',pausefnc); %set app data used to collect variable from here to be used in other functions



% --- Executes on button press in stpbtn.
function stpbtn_Callback(hObject, eventdata, handles)
% hObject    handle to stpbtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

player = getappdata(0,'player');

pausefnc = 0; %this is to stop a user pausing and then stopping

setappdata(0,'pausefnc',pausefnc);
stop(player); %this stops the player



% --- Executes on button press in plyFx.
function plyFx_Callback(hObject, eventdata, handles)
% hObject    handle to plyFx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
       dlyfnc = getappdata(0,'dlyfnc');
       tremfnc = getappdata(0,'tremfnc');        
        dstrtfnc = getappdata(0,'dstrtfnc');
        efct = getappdata(0,'efct');
         
pausefncfx = getappdata(0,'pausefncfx');

%variables collected to be used in IF statements
if efct == 0 %if no effects are being used, then the play, pause and stop buttons will have the same effect for
    %the original and edited signal

        if (pausefncfx == 0) %this is used to decide whether to play or resume the player in question
            %this format is used for each effect that could be used 
    

        player = getappdata(0,'player');
        play(player);
        'play'

        elseif (pausefncfx == 1)
    
        player = getappdata(0,'player');
        resume(player);
        pausefncfx = 0;
        'resume'
        end

elseif dlyfnc == 1    %delay function has the same format as before with different player to access    

    if pausefncfx == 0
        Dlysound = getappdata(0,'Dlysound');

    play(Dlysound);
    
    'playpausefnc'

    elseif pausefncfx == 1 
        
        Dlysound = getappdata(0,'Dlysound');
        
    resume(Dlysound);
    pausefncfx = 0;
    setappdata(0,'pausefncfx',pausefncfx);
    pausefncfx
    'resumepausefnc'
    end


elseif tremfnc == 1


    if pausefncfx == 0
        Tremsound = getappdata(0,'Tremsound');
    play(Tremsound);

    elseif pausefncfx == 1 
        Tremsound = getappdata(0,'Tremsound');
    resume(Tremsound);
        pausefncfx = 0;
    end

    
elseif dstrtfnc == 1

    if pausefncfx == 0
        
        dstrtsound = getappdata(0,'dstrtsound');
    play(dstrtsound);

    elseif pausefncfx == 1 
                dstrtsound = getappdata(0,'dstrtsound');
    resume(dstrtsound);
    pausefncfx = 0;

    
    end
    
setappdata(0,'pausefncfx',pausefncfx); %pause function set at the end of the code to allow pausefx and stopfx to 
%work correctly
end





% --- Executes on button press in pausebtnfx.
function pausebtnfx_Callback(hObject, eventdata, handles)
% hObject    handle to pausebtnfx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
       dlyfnc = getappdata(0,'dlyfnc');
       tremfnc = getappdata(0,'tremfnc');        
       dstrtfnc = getappdata(0,'dstrtfnc');
       efct = getappdata(0,'efct');
       
if efct == 0 %similar formatting to the play function, each effect is in an IF ELSEIF section of code. 
    %each effect gets the app data for its particular audioplayer and then
    %pauses it 
    
player = getappdata(0,'player');


pause(player);


    
    
elseif dlyfnc == 1        


Origsound = getappdata(0,'Origsound');
Dlysound = getappdata(0,'Dlysound');



pause(Origsound);
pause(Dlysound);

'delypause' 
%this was used to check the code was runinng through the whole way to bug
%fix while this code was still being tested. this repeats for all other
%effects


elseif tremfnc == 1

Tremsound = getappdata(0,'Tremsound');
pause(Tremsound);

'trempause'


elseif dstrtfnc == 1

dstrtsound = getappdata(0,'dstrtsound');
pause(dstrtsound); 

'dstrtpause'


end

pausefncfx = get(handles.pausebtnfx,'Value'); %getting the pause value to allow pausing work properly
setappdata(0,'pausefncfx',pausefncfx);
pausefncfx
%for purposes of debugging


% --- Executes on button press in Stopbtnfx.
function Stopbtnfx_Callback(hObject, eventdata, handles)
% hObject    handle to Stopbtnfx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
       dlyfnc = getappdata(0,'dlyfnc');
       tremfnc = getappdata(0,'tremfnc');        
       dstrtfnc = getappdata(0,'dstrtfnc');
       efct = getappdata(0,'efct');
       
       
if efct == 0 %similar to two other FX based pause,play functions, each effect 
    %has its own section in an IF ELSEIF loop.
    
player = getappdata(0,'player');

stop(player);           
           
elseif dlyfnc == 1        

Dlysound = getappdata(0,'Dlysound');

stop(Dlysound);


elseif tremfnc == 1

Tremsound = getappdata(0,'Tremsound');
stop(Tremsound);

elseif dstrtfnc == 1

dstrtsound = getappdata(0,'dstrtsound');
stop(dstrtsound);   

end

pausefncfx = 0; %set pause to 0 after stopping to avoid pausing then stopping
setappdata(0,'pausefncfx',pausefncfx);



% --- Executes on button press in svesmple.
function svesmple_Callback(hObject, eventdata, handles)
% hObject    handle to svesmple (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
        

        efct = getappdata(0,'efct'); %variable showing if effects are selected
        filename = getappdata(0,'filename');  %filename given by user input
        fs = getappdata(0,'fs'); %sampling frequency required for exporting (also used in certain functions)
        value = getappdata(0,'value'); %value used to select correct data if sample is cut
        
        dlyfnc = getappdata(0,'dlyfnc'); 
        tremfnc = getappdata(0,'tremfnc');        
        dstrtfnc = getappdata(0,'dstrtfnc'); %each effect is retrieved to allow that effect player to be 
        %exported
        
        format = getappdata(0,'format'); %format is a drop down list of accepted file extentsions allowed by
        %audiowrite 
        
filename = strcat(filename,format); %concatinate the two strings to give a filename and format

filename 
%filename used to test the filename concatination was working, and when it
%wasn't, to show what the filename was appearing as

if efct == 1 %having an initial if statement for the efct variable allows the audiowrite to know whether it is
    %trying to output a signal with or without the effects bus
    
        if dlyfnc == 1  %run through each of the effects to use for the export, depending on which one is set
            %as on or is equal to 1

    
        dlysig = getappdata(0,'dlysig'); 

        audiowrite(filename,dlysig,fs);

        elseif tremfnc == 1


         tremsig = getappdata(0,'tremsig');
        
        audiowrite(filename,tremsig,fs); %writing the file with the filename given by the user and
        %the particular set of y data (tremolo in this case) with the
        %sampling frequency
    
        elseif dstrtfnc == 1

    
        
        distortion = getappdata(0,'sig1');
        
        audiowrite(filename,distortion,fs);
   
        end
elseif efct == 0
   
if value == 0 %if effect's aren't on, then either the regular data or altered data (y) can be saved

y = getappdata(0,'y');        

audiowrite(filename,y,fs); 


elseif value == 1
    
%     data = getappdata(0,'data');
%     strtT = getappdata(0,'strtT');
%     endT = getappdata(0,'endT');
% 
% y = data(:,1);
% y = y(floor(strtT):endT);
%   
y=getappdata(0,'y');    
audiowrite(filename,y,fs);
end 
    
end
    



% --- Executes on button press in rtrnorig.
function rtrnorig_Callback(hObject, eventdata, handles)
% hObject    handle to rtrnorig (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

value = getappdata(0,'value'); 
fsorig = getappdata(0,'fsorig'); %original sampling frequency taken to 
%allow any changes to FS (speed up, slow down function) to be undone


fs = fsorig;
setappdata(0,'fs',fs); %set original fs to be the new fs 




if value == 0 %if the signal hasnt been chopped , the effects will be removed
    %from the original waveform

data = getappdata(0,'data');         


axes(handles.axes3);
N = size(data)-1; 
t = N/fs;
x=0:1/fs:t;

axes(handles.axes3);
plot(x,data); %new data is plotted against time to return to original 

y = data;  %y is reset to being the original data

setappdata(0,'y',y);



player = audioplayer(data,fs); %player is reset so when play function is used
%the original file(s) will be played
setappdata(0,'player',player);


elseif value == 1 %if audio is chopped, the audio is returned to being only
    %chopped, with no effects 
    
    data = getappdata(0,'data');
    strtT = getappdata(0,'strtT');
    endT = getappdata(0,'endT');

y = data(:,1);
y = y(floor(strtT):endT); %signal is set to its start time and end time array again
setappdata(0,'y',y) %new value for y set based off of the chopped data

    N = size(y)-1; 
    t = N/fs;
    x=0:1/fs:t;

  axes(handles.axes4);
  plot(x,y); %y value is plotted against time axis again
  
    
player = audioplayer(y,fs); %audioplayer created again to allow the signal to 
%be played again with no effects
setappdata(0,'player',player);
 
end

% --- Executes on button press in SlctFx.
function SlctFx_Callback(hObject, eventdata, handles)
% hObject    handle to SlctFx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --- Executes when selected object is changed in Fxgroup.
function Fxgroup_SelectionChangedFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in Fxgroup 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

selection = get(handles.Fxgroup,'SelectedObject'); %this tells the sampler which effect is selected
effect = get(selection,'String'); %getting the varaible as a string allows switch case logic to be used 
%to determine which effected is selected

setappdata(0,'selection', selection);
setappdata(0,'effect', effect);


switch effect %this logic allows the system to say when the effect is changed to any of the cases
    %then to run through the code under each case
    
    
    case 'Delay' %if delay is selected, a few things happen, the delay
        %function is set to 1 and the other functions are set to 0
        %these function variables are then set to be retrieved at a later
        %point.
        % the buttons and text boxes relating to the delay function are
        % then enabled and the other effects are disabled. 
        dlyfnc = 1;
        tremfnc = 0;
        dstrtfnc = 0;
        setappdata(0,'dlyfnc',dlyfnc);
        setappdata(0,'tremfnc',tremfnc);        
        setappdata(0,'dstrtfnc',dstrtfnc);
        set(handles.Aplydly,'enable','on');
        set(handles.Leveledit,'enable','on');
        set(handles.edtDlyTime,'enable','on');
        
        set(handles.Modtxt,'enable','off');
        set(handles.fctxt,'enable','off');
        set(handles.aplytrem,'enable','off');
        set(handles.dstrtgaintxt,'enable','off');
        set(handles.dstrtmixtxt,'enable','off');
        set(handles.applydstrt,'enable','off');
        
        
        sig1= getappdata(0,'sig1'); 
        sig2= getappdata(0,'sig2');
        
        sig1 = 0; %this is set to stop previous delay effects from interfering
        %with the new delay signal. and is repeated in all case's to stop 
        % the delay appearing in other effects when they are played, as
        % sig1 and sig2 only appear in the delay function
        sig2 = 0;
        
        setappdata(0,'sig1',sig1);
        setappdata(0,'sig2',sig2);
        
        
    case 'Tremolo' %this runs through the same as the delay case, but with 
        %all of the features relating to the tremolo being activated and
        %everything else being disabled.
        dlyfnc = 0;
        tremfnc = 1;
        dstrtfnc = 0;
        setappdata(0,'dlyfnc',dlyfnc);
        setappdata(0,'tremfnc',tremfnc);        
        setappdata(0,'dstrtfnc',dstrtfnc);
        %%Delay%%
        set(handles.Aplydly,'enable','off');
        set(handles.Leveledit,'enable','off');
        set(handles.edtDlyTime,'enable','off');
        
        set(handles.dstrtgaintxt,'enable','off');
        set(handles.dstrtmixtxt,'enable','off');
        set(handles.applydstrt,'enable','off'); 
        
        set(handles.Modtxt,'enable','on');
        set(handles.fctxt,'enable','on');
        set(handles.aplytrem,'enable','on');
        
        sig1= getappdata(0,'sig1');
        sig2= getappdata(0,'sig2');
        
        sig1 = 0;
        sig2 = 0;
        
        setappdata(0,'sig1',sig1);
        setappdata(0,'sig2',sig2);
        
        
        
    case 'Distortion'
        dlyfnc = 0;
        tremfnc = 0;
        dstrtfnc = 1;
        setappdata(0,'dlyfnc',dlyfnc);
        setappdata(0,'tremfnc',tremfnc);        
        setappdata(0,'dstrtfnc',dstrtfnc);
        %%Delay%%
        set(handles.Aplydly,'enable','off');
        set(handles.Leveledit,'enable','off');
        set(handles.edtDlyTime,'enable','off');
        
        set(handles.dstrtgaintxt,'enable','on');
        set(handles.dstrtmixtxt,'enable','on');
        set(handles.applydstrt,'enable','on');
        
        set(handles.Modtxt,'enable','off');
        set(handles.fctxt,'enable','off');
        set(handles.aplytrem,'enable','off');
        
        sig1= getappdata(0,'sig1');
        sig2= getappdata(0,'sig2');
        
        sig1 = 0;
        sig2 = 0;
        
        setappdata(0,'sig1',sig1);
        setappdata(0,'sig2',sig2);

end



function edtDlyTime_Callback(hObject, eventdata, handles)
% hObject    handle to edtDlyTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edtDlyTime as text
%        str2double(get(hObject,'String')) returns contents of edtDlyTime as a double

fs = getappdata(0,'fs');

dly = str2double(get(handles.edtDlyTime,'String')); %this collects the delay time 
%inputted 



Dlytime = dly *fs; %a delay time variable is created by mulitplying the delay with the sampling frequency
setappdata(0,'Dlytime',Dlytime);



% --- Executes during object creation, after setting all properties.
function edtDlyTime_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edtDlyTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Leveledit_Callback(hObject, eventdata, handles)
% hObject    handle to Leveledit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Leveledit as text
%        str2double(get(hObject,'String')) returns contents of Leveledit as a double


lvl = str2double(get(handles.Leveledit,'String')); %this collects the level value

setappdata(0,'lvl',lvl); %level set to be retrieved in the applydly function


function Leveledit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to leveledit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Aplydly.
function Aplydly_Callback(hObject, eventdata, handles)
% hObject    handle to Aplydly (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

Dlytime = getappdata(0,'Dlytime');
Dlytime = round(Dlytime); %Delay time rounded to avoid odd numbers causing
%issues. e.g. when testing 1.2 seconds of delay had an error as the number 
%wasn't an integer
lvl = getappdata(0,'lvl');
fs = getappdata(0,'fs');
delay = zeros(Dlytime,1); %vector of zeroes created using the delay time

value = getappdata(0,'value'); %value showing whether signal is cut or not

if value == 0
        
y = getappdata(0,'y');

y = y(:,1);
y2 = y*lvl;

sig1 = [y;delay];
sig2 = [delay;y2]; %two signals, with a delay at the start and end of both


    
elseif  value == 1
        
y = getappdata(0,'y');

y2 = y*lvl;

       
sig1 = [y;delay];
sig2 = [delay;y2];

end

setappdata(0,'sig1',sig1);
setappdata(0,'sig2',sig2);

dlysig = sig1+sig2; %both signals added together give the delayed sound

setappdata(0,'dlysig',dlysig);


Dlysound = audioplayer(dlysig,fs);
setappdata(0,'Dlysound',Dlysound);

N = size(dlysig)-1; 
t = N/fs;
x=0:1/fs:t;


plotsound = sig1 + sig2; %this is used to plot the sound against time 
setappdata(0,'plotsound',plotsound);
axes(handles.axes4);
plot(x,plotsound); %sound against time (dependent on if signal is chopped)




% --- Executes on button press in chopaud.
function chopaud_Callback(hObject, eventdata, handles)
% hObject    handle to chopaud (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of chopaud

value = get(handles.chopaud,'Value'); %this gives the value of "value" variable
setappdata(0,'value',value);
value
%for testing purposes, showed the value of the variable to allow for bug
%fixes




if value == 1 %if the variable is set to true, it allows access to the
    %chopped audio effects
set(handles.strtT,'enable','on');
set(handles.endT,'enable','on');
set(handles.Playchop,'enable','on');
data = getappdata(0,'data');
strtT = getappdata(0,'strtT');
endT = getappdata(0,'endT');

y = data(:,1);
y = y(floor(strtT):endT); 
setappdata(0,'y',y) %if the signal is set to being chopped, set y to be chopped value


elseif value == 0  %if it is deselected, the chopped audio function is inaccessible
set(handles.strtT,'enable','off');
set(handles.endT,'enable','off');
set(handles.Playchop,'enable','off');
data = getappdata(0,'data');  
y = data;
setappdata(0,'y',y);
end



% --- Executes on button press in applydstrt.
function applydstrt_Callback(hObject, eventdata, handles)
% hObject    handle to applydstrt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

gain = getappdata(0,'gain'); 
mix = getappdata(0,'mix');
%gain and mix values obtained from other functions

value = getappdata(0,'value');

if value == 0
y = getappdata(0,'y');
y = y(:,1);
q=y*gain/max(abs(y));
z=sign(-q).*(1-exp(sign(-q).*q));
yfuzz=mix*z*max(abs(y))/max(abs(z))+(1-mix)*y;
sig1=yfuzz*max(abs(y))/max(abs(yfuzz)); %exponential function used to define distortion

elseif value == 1 

y = getappdata(0,'y');

q=y*gain/max(abs(y));
z=sign(-q).*(1-exp(sign(-q).*q));
yfuzz=mix*z*max(abs(y))/max(abs(z))+(1-mix)*y;
sig1=yfuzz*max(abs(y))/max(abs(yfuzz));

end

setappdata(0,'sig1',sig1);

fs = getappdata(0,'fs');
dstrtsound = audioplayer(sig1,fs); %distortion sound is defined using sampling frequency
%and the new sig1 variable

setappdata(0,'dstrtsound',dstrtsound);  

N = size(y)-1; 
t = N/fs;
x=0:1/fs:t;

axes(handles.axes4);
plot(x,sig1); 

function dstrtmixtxt_Callback(hObject, eventdata, handles)
% hObject    handle to dstrtmixtxt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of dstrtmixtxt as text
%        str2double(get(hObject,'String')) returns contents of dstrtmixtxt as a double

mix = str2double(get(handles.dstrtmixtxt,'String')); %mix value converted to a double from the text box
setappdata(0,'mix',mix);

% --- Executes during object creation, after setting all properties.
function dstrtmixtxt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dstrtmixtxt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function dstrtgaintxt_Callback(hObject, eventdata, handles)
% hObject    handle to dstrtgaintxt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of dstrtgaintxt as text
%        str2double(get(hObject,'String')) returns contents of dstrtgaintxt as a double

gain = str2double(get(handles.dstrtgaintxt,'String')); %gain value converted from string to double
setappdata(0,'gain',gain);

% --- Executes during object creation, after setting all properties.
function dstrtgaintxt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dstrtgaintxt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Modtxt_Callback(hObject, eventdata, handles)
% hObject    handle to Modtxt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Modtxt as text
%        str2double(get(hObject,'String')) returns contents of Modtxt as a double

mod = str2double(get(handles.Modtxt,'String')); %modulation value collected as a double to be used later
setappdata(0,'mod',mod);


% --- Executes during object creation, after setting all properties.
function Modtxt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Modtxt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function fctxt_Callback(hObject, eventdata, handles)
% hObject    handle to fctxt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of fctxt as text
%        str2double(get(hObject,'String')) returns contents of fctxt as a double

fc = str2double(get(handles.fctxt,'String')); %fc variable collected as a double 
setappdata(0,'fc',fc);



% --- Executes during object creation, after setting all properties.
function fctxt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fctxt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in aplytrem.
function aplytrem_Callback(hObject, eventdata, handles)
% hObject    handle to aplytrem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
mod = getappdata(0,'mod');
fc = getappdata(0,'fc');
fs = getappdata(0,'fs');
value = getappdata(0,'value'); %value used to show whether signal is cut or not
data = getappdata(0,'data'); %used to plot for time
%variables from the tremolo function retrieved to be used in the formula

if value == 0
y = getappdata(0,'y');    
%y = data(:,1);
y = y';

index = 1:length(y); %index used to make the sinewave the same length as
%the signal 

trem = (1+mod*sin(2*pi*index*(fc/fs)))'; %tremolo function uses a sine wave
%as its carrier wave which changes the sound of the function
trem = trem';

N = size(data)-1; 
t = N/fs;
x=0:1/fs:t;


elseif value == 1
y = getappdata(0,'y');

N = size(y)-1; 
t = N/fs;
x=0:1/fs:t;

y = y';
index = 1:length(y);

trem = (1+mod*sin(2*pi*index*(fc/fs)));   




end



tremsig = trem.*y; %the new tremolo function is then . multiplied with the 
%data to give the final signal with the tremolo effect
setappdata(0,'tremsig',tremsig);
axes(handles.axes4);


plot(x,tremsig); %plot the tremsig against time


Tremsound = audioplayer(tremsig,fs);
setappdata(0,'Tremsound',Tremsound);



% --- Executes on button press in rvrsebtn.
function rvrsebtn_Callback(hObject, eventdata, handles)
% hObject    handle to rvrsebtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
value = getappdata(0,'value');
fs = getappdata(0,'fs');
'reverse'



if value == 0
    
data = getappdata(0,'data');

y = flipud(data); %this flips the data upside down, which gives the desired
%effect of reverse the wave

player = audioplayer(y,fs); %this is then the new definition for the player
%to allow for further editing
setappdata(0,'player',player);


N = size(y)-1; 
t = N/fs;
x=0:1/fs:t;
axes(handles.axes3)
plot(x,y);

setappdata(0,'y',y); %y value changed to allow for further editing

elseif value == 1

        
y = getappdata(0,'y');

y = flipud(y);

N = size(y)-1; 
t = N/fs;
x=0:1/fs:t;
axes(handles.axes4)
plot(x,y);


setappdata(0,'y',y);
        
end



% --- Executes on button press in spdup.
function spdup_Callback(hObject, eventdata, handles)
% hObject    handle to spdup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
fs = getappdata(0,'fs');

y = getappdata(0,'y'); %y data is collected 
fs = fs*2; %if the data is multiplied by 2, the wave is twice as fast
%a further function in which a user inputted speed up could be implemented 
%fairly easy, by having a box in which the user chose a speed, and then the
%signal would be mulitplied by that number, where 2 would be replaced by
%that variable 
N = size(y)-1; 
t = N/fs;
x=0:1/fs:t;
axes(handles.axes4)
plot(x,y);



player = audioplayer(y,fs); %new definition for player to allow new signal to 
%be played
setappdata(0,'player',player);


setappdata(0,'fs',fs);


% --- Executes on button press in slwdwn.
function slwdwn_Callback(hObject, eventdata, handles)
% hObject    handle to slwdwn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% this function works identically to spdup, with the only difference being
% the fs is divided by 2 rather than multiplied
value = getappdata(0,'value');
fs = getappdata(0,'fs');
    
y = getappdata(0,'y'); 
fs = fs/2;
N = size(y)-1; 
t = N/fs;
x=0:1/fs:t;
axes(handles.axes4)
plot(x,y);


player = audioplayer(y,fs);
setappdata(0,'player',player);


setappdata(0,'fs',fs);




function filename_Callback(hObject, eventdata, handles)
% hObject    handle to filename (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of filename as text
%        str2double(get(hObject,'String')) returns contents of filename as a double

filename = (get(handles.filename,'String')); %the filename is collected as 
%as a string and is set as a variable to be used in the save function later
setappdata(0,'filename',filename);

% --- Executes during object creation, after setting all properties.
function filename_CreateFcn(hObject, eventdata, handles)
% hObject    handle to filename (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in extension.
function extension_Callback(hObject, eventdata, handles)
% hObject    handle to extension (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns extension contents as cell array
%        contents{get(hObject,'Value')} returns selected item from extension

contents = cellstr(get(hObject,'String')); %the extension contents are selected
format = contents{get(hObject,'Value')}; %the particular cell selected is then
%extracted and saved as a string
setappdata(0,'format',format);

% --- Executes during object creation, after setting all properties.
function extension_CreateFcn(hObject, eventdata, handles)
% hObject    handle to extension (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
