clc, clear, close all 

cfg.ENSITE_V = 'precision'; %choices: 'precision', 'x1'
cfg.DIR_PATH = '/media/jakubhejc/hejc_usb04/study_dwsG701583_2021_07_13_12_08_28/081-RA-followup_2022_08_24_12_13_39';
cfg.GEOMETRY_FILE = 'ModelGroups.xml';


% ----------------LOAD GEOMETRY---------------- 
% This needs to be updated to work without ModelGroups!!!!!!!!!!
%dxgeo = loadprecision_modelgroups(fullfile(cfg.DIR_PATH, cfg.GEOMETRY_FILE));

tr = processprecision_modelgroups(dxgeo.dxgeo);
hFig = plotprecision_modelgroups(tr, dxgeo.dxgeo);

% Get current axes obj
axObj = hFig{1}.CurrentAxes;
hold(axObj)


%% Convert rendered model to graph
edges = tr{1}.edges;
nb_edges = size(edges, 1);

%compute the length of each edge (square root is omitted fot better performance)
edge_start = tr{1}.Points(edges(:, 1), :);
edge_end = tr{1}.Points(edges(:, 2), :);

weights = sum((edge_start - edge_end) .^2, 2);

% Create undirected weighted graph
G = graph(edges(:, 1), edges(:, 2), weights);
G.Nodes = array2table(tr{1}.Points, 'VariableNames', {'X','Y','Z'});


%% Area segmentation
pathNodeClicked = [8899, 7764, 6426, 3750, 2156, 1413, 2057, 3305, 6170, 8052];

% Close global path by extending vector by the first node
pathNodeClicked = [pathNodeClicked, pathNodeClicked(1)];

pathNodeInds = [];
for i = 1:(length(pathNodeClicked) - 1)
    % Shortest path between two nodes
    twoNodePath = shortestpath(G, pathNodeClicked(i), pathNodeClicked(i+1));
    
    % Append to global path
    pathNodeInds = [
        pathNodeInds, twoNodePath(1:end-1)
        ];
end


% Get path nodes coordinates

h = plot(axObj, G,'XData',G.Nodes.X,'YData',G.Nodes.Y,'ZData',G.Nodes.Z, 'LineStyle', 'none', 'MarkerSize', 1);
highlight(h, pathNodeInds, 'EdgeColor','r', 'LineStyle', '-', 'LineWidth',2)


