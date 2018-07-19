classdef rl_agent < matlab.System & matlab.system.mixin.Propagates ...
        & matlab.system.mixin.CustomIcon & matlab.system.mixin.Nondirect
    % untitled Add summary here
    %
    % NOTE: When renaming the class name untitled, the file name
    % and constructor name must be updated to use the class name.
    %
    % This template includes most, but not all, possible properties, attributes,
    % and methods that you can implement for a System object in Simulink.

    % Public, tunable properties
    properties
       
    end

    % Public, non-tunable properties
    properties(Nontunable)
       input_range;
       agent;
    end

    properties(DiscreteState)

    end

    % Pre-computed constants
    properties(Access = private)
        state;
        reward;
    end

%     methods
%         % Constructor
%         function obj = untitled(varargin)
%             % Support name-value pair arguments when constructing object
%             setProperties(obj,nargin,varargin{:})
%         end
%     end

    methods(Access = protected)
        %% Common functions
        function setupImpl(obj)
            % Perform one-time calculations, such as computing constants
            obj.input_range = evalin('base', 'input_range');
            obj.agent = evalin('base', 'agent');
        end

        function action = outputImpl(obj, ~)
            action_normalized = double(py.driver.driver(obj.agent, obj.state', obj.reward(1)));
            action_normalized = min([1.0 1.0], max([-1.0 -1.0], action_normalized));
            lower = obj.input_range(:,1)';
            upper = obj.input_range(:,2)';
            middle = (lower + upper)/2.0;
            action = (action_normalized .* (upper - middle) + middle)'; 
        end
        
        function updateImpl(obj, u)
            obj.state = u(2:end);
            obj.reward = u(1);
        end
        
%         function y = stepImpl(obj,u)
%             % Implement algorithm. Calculate y as a function of input u and
%             % discrete states.
%             y = u;
%         end
% 
%         function resetImpl(obj)
%             % Initialize / reset discrete-state properties
%         end

        %% Backup/restore functions
        function s = saveObjectImpl(obj)
            % Set properties in structure s to values in object obj

            % Set public properties and states
            s = saveObjectImpl@matlab.System(obj);

            % Set private and protected properties
            %s.myproperty = obj.myproperty;
        end

        function loadObjectImpl(obj,s,wasLocked)
            % Set properties in object obj to values in structure s

            % Set private and protected properties
            % obj.myproperty = s.myproperty; 

            % Set public properties and states
            loadObjectImpl@matlab.System(obj,s,wasLocked);
        end

        %% Simulink functions
        function ds = getDiscreteStateImpl(~)
            % Return structure of properties with DiscreteState attribute
            ds = struct([]);
        end

        function flag = isInputSizeMutableImpl(~,~)
            % Return false if input size cannot change
            % between calls to the System object
            flag = false;
        end

        function out = getOutputSizeImpl(~)
            % Return size for each output port
            out = [1 1];

            % Example: inherit size from first input port
            % out = propagatedInputSize(obj,1);
        end

        function icon = getIconImpl(~)
            % Define icon for System block
            icon = mfilename("class"); % Use class name
            % icon = "My System"; % Example: text icon
            % icon = ["My","System"]; % Example: multi-line text icon
            % icon = matlab.system.display.Icon("myicon.jpg"); % Example: image file icon
        end
    end

    methods(Static, Access = protected)
        %% Simulink customization functions
        function header = getHeaderImpl
            % Define header panel for System block dialog
            header = matlab.system.display.Header(mfilename("class"));
        end

        function group = getPropertyGroupsImpl
            % Define property section(s) for System block dialog
            group = matlab.system.display.Section(mfilename("class"));
        end
    end
end
