from subprocess import check_output
from sys import executable
from unittest import TestCase


class TestSortVariableLength(TestCase):

    def test(self) -> None:
        """TODO
        """
        test_lines = './test/test_lines.txt'
        program = './sort_variable_length.py'
        command = f'cat {test_lines} | {executable} {program}' 
        stdout = check_output(command, shell=True)
        print(stdout)
        self.assertTrue(True)


