import sys
import tty
import termios

# Define the options and questions
options = ['project', 'extension']
questions = ['What would you like to create?', 'Select an option:']

# Define a function to get the user's selection
def get_selection():
    # Save the terminal settings
    old_settings = termios.tcgetattr(sys.stdin)
    try:
        # Set the terminal to raw mode
        tty.setraw(sys.stdin)
        # Print the questions and options
        for question, option in zip(questions, options):
            print(question)
            for i, opt in enumerate(options):
                print(f"{'❯' if i == 0 else ' ' } {opt}")
            # Get the user's selection
            while True:
                char = sys.stdin.read(1)
                if char == '\x1b':  # arrow keys
                    sys.stdin.read(2)  # discard the next two characters
                    if char == '\x1b[A':  # up arrow
                        options = [options[-1]] + options[:-1]
                    elif char == '\x1b[B':  # down arrow
                        options = options[1:] + [options[0]]
                    # Re-print the options with the new selection
                    print(question)
                    for i, opt in enumerate(options):
                        print(f"{'❯' if i == 0 else ' ' } {opt}")
                elif char == '\r':  # enter key
                    return options[0]
    finally:
        # Restore the terminal settings
        termios.tcsetattr(sys.stdin, termios.TCSADRAIN, old_settings)

# Call the function to get the user's selection
selected_option = get_selection()
print(f"You selected '{selected_option}'")
