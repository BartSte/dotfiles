from sys import stdin

def find_equal_sign(obj: str) -> int:
    """Returns the index of the = sign.

    Args:
        obj (str): a string that may contain an `=' sign.

    Returns:
        int: the location of the first `=' sign.
    """
    return obj.find('=')


if __name__ == '__main__':
    lines = stdin.read().splitlines()
    lines.sort(key=find_equal_sign)
    stdout = '\n'.join(lines)
    print(stdout)

