from sys import stdin


def sort_variable_length(lines: str) -> str:
    """Sorts lines of variables definitions base on the number of characters
    before the `=' sign.

    Args:
        lines (str): variable definitions separated by `\n'.

    Returns:
        str: sorted variable definitions separated by `\n'.
    """
    as_list = lines.splitlines()
    as_list.sort(key=find_equal_sign)
    return '\n'.join(as_list)


def find_equal_sign(obj: str) -> int:
    """Returns the index of the = sign.

    Args:
        obj (str): a string that may contain an `=' sign.

    Returns:
        int: the location of the first `=' sign.
    """
    return obj.find('=')


if __name__ == '__main__':
    lines = stdin.read()
    stdout = sort_variable_length(lines)
    print(stdout)
