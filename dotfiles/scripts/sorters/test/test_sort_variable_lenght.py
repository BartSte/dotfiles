from subprocess import check_output
from sys import executable
from unittest import TestCase


class TestSortVariableLength(TestCase):

    EXPECTED = b'\n=;\nx = 1;\nxx = 2;\nxxx = 3;\nxxxx = 4;\nxxxxx === 5;\n'

    def test(self) -> None:
        """TODO."""
        test_lines = './test/test_lines.txt'
        program = './sort_variable_length.py'
        command = f'bat {test_lines} | {executable} {program}'
        stdout = check_output(command, shell=True)
        self.assertEqual(self.EXPECTED, stdout)
