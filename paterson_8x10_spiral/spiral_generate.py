import sys, getopt
import math

import madcad

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
    result = [[], []]
    (b, theta_1, theta_2) = spiral_param;
    theta = theta_1
    while theta < theta_2:
        result[0].append(convert_from_polar_to_cartesian_coordinates((theta, b*theta)))
        result[1].append(convert_from_polar_to_cartesian_coordinates((theta + math.pi, b*theta)))
        theta = theta + step_radian
    return result

def calculate_support_dots(spirals, number, spiral_width):

    result = [[] for i in range(number)]

    (b, theta_1, theta_2) = spirals;
    theta = theta_1
    while theta < theta_1 + 2*math.pi - 0.1:
        i = int(((theta-theta_1)*number/(2*math.pi)))

        x = []
        y = [0]
        for r in range(0, int((theta_2)/(2*math.pi))+1):
            x = x + [b*(theta%math.pi + r*2*math.pi), b*(theta%math.pi + r*2*math.pi + math.pi)]
            y = y + [b*(theta%math.pi + r*2*math.pi), b*(theta%math.pi + r*2*math.pi + math.pi)]

        max_l = b*theta_2
        for l in zip(y,x):

            if l[0] == 0:
                result[i].append([convert_from_polar_to_cartesian_coordinates((theta, l[0])),
                                  convert_from_polar_to_cartesian_coordinates((theta, l[1] - spiral_width/2))])
            elif l[0] < max_l and l[1] < max_l:
                result[i].append([convert_from_polar_to_cartesian_coordinates((theta, l[0] + spiral_width/2)),
                                  convert_from_polar_to_cartesian_coordinates((theta, l[1] - spiral_width/2))])
        theta = theta + 2*math.pi/number

    return result

def calculate_enterance_dots(spirals, spiral_width, angle_offset):
    result = []

    (b, theta_1, theta_2) = spirals;

    x = [(theta_2-angle_offset, b*(theta_2-angle_offset)+spiral_width),
         (theta_2+math.pi-angle_offset, b*(theta_2-angle_offset)+spiral_width)]
    y = [(theta_2-2*math.pi-angle_offset, b*(theta_2-math.pi*2-angle_offset)+spiral_width),
         (theta_2-2*math.pi + math.pi -angle_offset, b*(theta_2-math.pi*2-angle_offset)+spiral_width)]

    for l in zip(y,x):
        result.append([convert_from_polar_to_cartesian_coordinates(l[0]),
                       convert_from_polar_to_cartesian_coordinates(l[1])])
    return result

def convert_from_polar_to_cartesian_coordinates(point):
    return (point[1]*math.cos(point[0]), point[1]*math.sin(point[0]))

def get_bottom_spirale_profile(base_point):
    O = madcad.Point(0, 0, 0)
    X = madcad.Point(1, 0, 0)
    Y = madcad.Point(0, 1, 0)
    Z = madcad.Point(0, 0, 1)
    axe_z = madcad.Axis(O,Z)
    axe_y = madcad.Axis(O,Y)


    p1 = madcad.flatsurface(madcad.wire(madcad.Softened([madcad.Point(-3, 0, 0),
                                                         madcad.Point(-2.8, 0, 2),
                                                         madcad.Point(-1.4, 0, 4),
                                                         madcad.Point(-1.2, 0, 2),
                                                         madcad.Point(-1, 0, 0)])))
    p2 = madcad.flatsurface(madcad.wire(madcad.Softened([madcad.Point(3, 0, 0),
                                                         madcad.Point(2.8, 0, 2),
                                                         madcad.Point(1.4, 0, 4),
                                                         madcad.Point(1.2, 0, 2),
                                                         madcad.Point(1, 0, 0)])))

    p3 = madcad.flatsurface(madcad.wire([madcad.Point(-3, 0, 0),
                                         madcad.Point(-3, 0, -2),
                                         madcad.Point(-1, 0, -2),
                                         madcad.Point(-1, 0, 0)]))
    p4 = madcad.flatsurface(madcad.wire([madcad.Point(3, 0, 0),
                                         madcad.Point(3, 0, -2),
                                         madcad.Point(1, 0, -2),
                                         madcad.Point(1, 0, 0)]))
    angle =- madcad.anglebt(Y, base_point[1]-base_point[0])

    rotate = madcad.rotatearound(angle, axe_z)

    return [p1.transform(rotate).transform(base_point[0]),
            p2.transform(rotate).transform(base_point[0]),
            p3.transform(rotate).transform(base_point[0]),
            p4.transform(rotate).transform(base_point[0])]


def get_bottom_suport_profile(base_point):
    O = madcad.Point(0, 0, 0)
    X = madcad.Point(1, 0, 0)
    Y = madcad.Point(0, 1, 0)
    Z = madcad.Point(0, 0, 1)
    axe_z = madcad.Axis(O,Z)
    axe_y = madcad.Axis(O,Y)


    p = madcad.flatsurface(madcad.wire([madcad.Point(-1, 0, 0),
                                        madcad.Point(-1, 0, -2),
                                        madcad.Point( 1, 0, -2),
                                        madcad.Point( 1, 0, 0)]))
    angle = madcad.anglebt(Y, base_point[1] - base_point[0])
    #if(angle > math.pi/2):
    if base_point[1].x > 0:
        angle = -angle

    rotate = madcad.rotatearound(angle, axe_z)
    return p.transform(rotate).transform(base_point[0])

def genearate_spiral(curve, support, profile_spital_generator, profile_support_generator):
    lines = []

    for line in curve:
        profile = profile_spital_generator([madcad.Point(line[0][0], line[0][1], 0),
                                        madcad.Point(line[1][0], line[1][1], 0)])
        for p in profile:
            tube = madcad.tube(
                p,
                madcad.Interpolated([madcad.Point(x, y, 0) for x,y in line]))

            tube.mergeclose()
            tube.check()
            lines.append(tube)

    for s in support:
        lines.append(madcad.tube(
            profile_support_generator([madcad.Point(s[0][0][0], s[0][0][1], 0),
                                       madcad.Point(s[-1][-1][0], s[-1][-1][1], 0)]),
            madcad.Segment(madcad.Point(s[0][0][0], s[0][0][1], 0),
                           madcad.Point(s[-1][-1][0], s[-1][-1][1], 0))))
    result = lines[0]
    for l in lines[1:]:
        l.check()
        if not l.issurface():
            madcad.show([l])
        assert l.issurface()
        result = result + l
    result.check()
    return result


def generate_bottom_spiral(dots, support):
    result = genearate_spiral(dots, support, get_bottom_spirale_profile, get_bottom_suport_profile)
    result.check()

    return result

def generate_test(curve, support, enterance):
    test = []

    for line in curve:
        test.append(madcad.Interpolated([madcad.Point(x, y, 0) for x,y in line]))
        test.append(get_bottom_spirale_profile([madcad.Point(line[0][0], line[0][1], 0),
                                                madcad.Point(line[1][0], line[1][1], 0)]))
        test.append(madcad.Point(line[0][0], line[0][1], 0) - madcad.Point(line[1][0], line[1][1], 0))
        test.append([madcad.Point(line[0][0], line[0][1], 0), madcad.Point(line[1][0], line[1][1], 0)])
    for s in support:
        test.append(madcad.Segment(madcad.Point(s[0][0][0], s[0][0][1], 0),
                                   madcad.Point(s[-1][-1][0], s[-1][-1][1], 0)));
        test.append(get_bottom_suport_profile([madcad.Point(s[0][0][0], s[0][0][1], 0),
                                               madcad.Point(s[-1][-1][0], s[-1][-1][1], 0)]))
    return test


def generate_spiral_stl(dots, support, enterance_dots):
    bottom = generate_bottom_spiral(dots, support)
    madcad.show([bottom])
    madcad.show(generate_test(dots, support, enterance_dots))
    madcad.write(bottom, "bottom_generated.stl")

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
    spiral_param = find_spiral_parameters(int_d, ext_d, length)
    #test()
    generate_spiral_stl(calculate_spiral_dots(spiral_param, 0.01),
                        calculate_support_dots(spiral_param, 8, -3),
                        calculate_enterance_dots(spiral_param, 3, math.pi/16))



if __name__ == "__main__":
   main(sys.argv)
