function TranslateModelToCenterOfMass(root, objectName, C)
    [root, ~] = GetCurrentRootAndScenario();
    
    root.ExecuteCommand(sprintf('VO */Satellite/%s ModelOffset Translational On %.5f %.5f %.5f', objectName, -C(1), -C(2), -C(3)))
end