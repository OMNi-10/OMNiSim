% 
% 
% function path = findPath(system, target)
%     if isa(system, "SystemManager")
%         for subsys = system.subSystems
%             subpath = findPath(subsys, target);
%             if ~isempty(subpath)
%                 path = system.S_name + system.delimiter + subpath;
%                 break
%             end
%         end
%     elseif (system == target)
%         path = system.S_name + system.delimiter;
%     elseif (system.S_name == target)
%         path = target + system.delimiter;
%     else
%         path = string.empty();
% end