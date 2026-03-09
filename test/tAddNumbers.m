classdef tAddNumbers < matlab.unittest.TestCase
    methods(Test)
        function testPositiveNumbers(testCase)
            actual = addNumbers(2, 3);
            expected = 5;
            testCase.verifyEqual(actual, expected);
        end

        function testNegativeNumbers(testCase)
            actual = addNumbers(-4, -6);
            expected = -10;
            testCase.verifyEqual(actual, expected);
        end

        function testZero(testCase)
            actual = addNumbers(0, 0);
            expected = 0;
            testCase.verifyEqual(actual, expected);
        end
    end
end