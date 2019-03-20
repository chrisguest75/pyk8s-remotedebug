import time
import ptvsd
import argparse
import os


def str2bool(v):
    return v.lower() in ("yes", "true", "t", "1")


if __name__ == "__main__":
    print(f"Enter {__name__}")
    parser = argparse.ArgumentParser(description='Import a bot test')
    parser.add_argument('--debugger', dest='debugger', action='store_true')
    parser.add_argument('--wait', dest='wait', action='store_true')
    args = parser.parse_args()

    debugger = False
    if 'DEBUGGER' in os.environ:
        debugger = str2bool(os.environ['DEBUGGER'])
        print(f"DEBUGGER found in environment {debugger}")
    if args.debugger:
        debugger = True

    wait = False
    if 'WAIT' in os.environ:
        wait = str2bool(os.environ['WAIT'])
        print(f"WAIT found in environment {wait}")
    if args.wait:
        wait = True

    if debugger:
        # 5678 is the default attach port in the VS Code debug configurations
        print("Debugger activated")
        ptvsd.enable_attach(address=('0.0.0.0', 5678), redirect_output=True)
        if wait:
            print("Waiting for debugger attach")
            ptvsd.wait_for_attach()
            breakpoint()

    count = 0
    while True:
        print(f"Hello World - {count}")
        count += 1
        time.sleep(10)
