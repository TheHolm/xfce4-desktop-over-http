import sys
import os
import signal

def write_stdout(s):
    # only eventlistener protocol messages may be sent to stdout
    sys.stdout.write(s)
    sys.stdout.flush()

def write_stderr(s):
    sys.stderr.write(s)
    sys.stderr.flush()

def main():
    while True:

        try:
            TERM_ON_LOGOUT = str(os.environ['TERMINATE_ON_LOGOUT'])
        except KeyError:
            TERM_ON_LOGOUT = 'No'

        TERM_ON_LOGOUT =  TERM_ON_LOGOUT.lower() in ('yes', 'true')

        # transition from ACKNOWLEDGED to READY
        write_stdout('READY\n')

        # read header line
        line = sys.stdin.readline()

        # read event payload
        headers = dict([ x.split(':') for x in line.split() ])
        data = sys.stdin.read(int(headers['len']))
        if headers['eventname'] in ('PROCESS_STATE_STOPPED', 'PROCESS_STATE_EXITED', 'PROCESS_STATE_FATAL'):
            data = dict([ x.split(':') for x in data.split() ])
            # write_stderr(headers['eventname'] + '-' + data['processname'] + "\n")
            if TERM_ON_LOGOUT and data['processname'] == 'startxfce4' :
                # sending SIGTERM to supervisord ( whic always run is PID=1)
                os.kill(1, signal.SIGTERM)
        else:
            pass
            # write_stderr(headers['eventname'] + "\n")

        # transition from READY to ACKNOWLEDGED
        write_stdout('RESULT 2\nOK')

if __name__ == '__main__':
    main()
