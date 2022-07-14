import matplotlib as mp
import matplotlib.pyplot as plt
import sys, getopt
import math

def calculate_spiral_length(theta, b):
    return (b/2*(theta*math.sqrt(1 + theta*theta) + math.log(theta + math.sqrt(1 + theta*theta))))

def calculate_spiral_length_between_d(int_d, ext_d, b):
    theta_1 = (int_d/2)/b
    theta_2 = (ext_d/2)/b
    len_int = calculate_spiral_length(theta_2, b) - calculate_spiral_length(theta_1, b)
    return (theta_1, theta_2, len_int)

def find_spiral_parameters(int_d, ext_d, length):
    print("Try to find spiral parameters")
    b = 0.1
    for b in [float(x)/100 for x in  range(1, 1000000, 1)]:
        (theta_1, theta_2, length_calculated) = calculate_spiral_length_between_d(int_d, ext_d, b)
        if length_calculated > length and length_calculated < length+10:
            print("Find spiral: b = {}, theta_1 = {}, theta2 = {}, length = {}".format(b, theta_1, theta_2, length_calculated))
            return (b, theta_1, theta_2)
        #else:
        #    print("Check spiral: b = {}, theta_1 = {}, theta2 = {}, length = {}".format(b, theta_1, theta_2, length_calculated))
            
    print("Error, cannot find spiral")
    return (0,0,0)

def calculate_spiral_dots(spiral_param, step_radian):
    theta = 0
    result = (([], []), ([], []))
    (b, theta_1, theta_2) = spiral_param;
    theta = theta_1
    while theta < theta_2:
        result[0][0].append(theta-theta_2)
        result[0][1].append(b*theta)
        result[1][0].append(theta-theta_2 + math.pi)
        result[1][1].append(b*theta)
        theta = theta + step_radian
    return result

def print_graph(dots, ext_d):
    #fig = plt.figure(figsize=(ext_d/25.4, ext_d/25.4), dpi=100, frameon=False)
    fig = plt.figure(figsize=(ext_d/25.4, ext_d/25.4), dpi=100, frameon=False)

    #ax = fig.add_subplot(111)
    p = plt.polar(dots[0][0], dots[0][1], '-', linewidth=4)
    p = plt.polar(dots[1][0], dots[1][1], '-', linewidth=4)
    plt.axis("off")

    mp.rcParams['lines.linewidth'] = 40
    plt.savefig("spiral.svg", format="svg", transparent=True, dpi=100, bbox_inches='tight')
    #plt.savefig("spiral.svg", format="svg", transparent=False, dpi=100, bbox_inches='tight')
    plt.axis("on")
    plt.show()

def main(argv):
    int_d = 10
    ext_d = 150
    length = 10*25.4
    try:
        opts, args = getopt.getopt(argv[1:],"hd:D:l:")
    except getopt.GetoptError:
        print('Incorrect options. Use -h for help')
        sys.exit(2)
    for opt, arg in opts:
        if opt == '-h':
            print(argv[0] + ' -d <internal diameter> -D <external diameter> -l <needed length>')
            sys.exit()
        elif opt in ("-d"):
            int_d = int(arg)
        elif opt in ("-D"):
            ext_d = int(arg)
        elif opt in ("-l"):
            length = int(arg)

    print('d= ',int_d)
    print('D= ',ext_d)
    print('L= ',length)
    print_graph(calculate_spiral_dots(find_spiral_parameters(int_d, ext_d, length), 0.01), ext_d)


if __name__ == "__main__":
   main(sys.argv)
