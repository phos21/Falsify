function [numEpisode, elapsedTime, bestRob, bestXout, bestYout] = falsify(config)

    function [T,Y] = yout2TY(yout, outputs)
        for i=1:length(outputs)
            index = outputs(i);
            T = yout.getElement(index).Values.Time; % danger
            Y(:,i) = yout.getElement(index).Values.Data;
        end
    end

    function [xout, yout] = runsim(agent, config)
        %mws = get_param(config.mdl, 'modelworkspace');
        assignin('base', 'Phi', config.monitoringFormula);
        assignin('base', 'Pred', config.preds);
        assignin('base', 'agent', agent);
        set_param([config.mdl, '/MATLAB Function'], 'SystemSampleTime', num2str(config.sampleTime));
        simOut = sim(config.mdl,'SimulationMode','normal','AbsTol','1e-5',...
                     'SaveState','on','StateSaveName','xout',...
                     'SaveOutput','on','OutputSaveName','yout',...
                     'SaveFormat', 'Dataset',...
                     'StopTime', num2str(config.stopTime));
        xout = simOut.get('xout');
        yout = simOut.get('yout');
    end

    function [rob] = robustness(target, preds, yout, outputs)
        [T,Y] = yout2TY(yout, outputs);
        rob =  dp_taliro(target, preds, Y, T, [], [], []);
    end
    
    bestRob = inf;
    agent = py.driver.start_learning();
    tic;
    for numEpisode=1:config.maxEpisodes
        [xout, yout] = runsim(agent, config);
        rob = robustness(config.targetFormula, config.preds, yout, config.outputs);
        py.driver.stop_episode(agent);
        disp(['Current iteration: ', num2str(numEpisode), ', rob = ', num2str(rob)])
        if rob < bestRob
            bestRob = rob;
            bestYout = yout;
            bestXout = xout;
            if rob < 0 
                break;
            end
        end
    end
    elapsedTime = toc;
end

