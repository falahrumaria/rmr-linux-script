import sys


def add_dict(my_dict, line):
    texts = line.split('=')
    key = texts[0].strip()
    if key != '':
        if len(texts) > 1:
            my_dict[key] = texts[1].strip()
        else:
            my_dict[key] = ''


def make_dict(f, first_line='#') -> dict:
    my_dict = {}
    if not first_line.startswith('#'):
        add_dict(my_dict, first_line)
    for line in f:
        if not line.startswith('#'):
            add_dict(my_dict, line)
    f.close()
    return my_dict


def build_properties():
    f1 = open(
        '{}/src/main/resources/application-production.properties'.format(base_uri), 'r')
    f2 = open(
        '{}/src/main/resources/application-development.properties'.format(base_uri), 'r')
    main_properties = make_dict(f0, first_line)
    prod_properties = make_dict(f1)
    dev_properties = make_dict(f2)
    print('<<<<<<<<<< duplicate in main and prod >>>>>>>>>>')
    for key in (prod_properties.keys() & main_properties.keys()):
        if prod_properties[key] == main_properties[key]:
            print('{}={}'.format(key, prod_properties[key]))
            prod_properties.pop(key)

    print('<<<<<<<<<< duplicate in main and dev >>>>>>>>>>')
    for key in (dev_properties.keys() & main_properties.keys()):
        if dev_properties[key] == main_properties[key]:
            print('{}={}'.format(key, dev_properties[key]))
            dev_properties.pop(key)

    with open(uri, 'w') as f:
        f.write('#built - do not delete this line!\n')
        print('<<<<<<<<<< duplicate in prod and dev >>>>>>>>>>')
        for key in (prod_properties.keys() & dev_properties.keys()):
            if prod_properties[key] == dev_properties[key]:
                print('{}={}'.format(key, prod_properties[key]))
                main_properties[key] = prod_properties[key]
                prod_properties.pop(key)
                dev_properties.pop(key)

        main_diff_prod = main_properties.keys() - prod_properties.keys()
        main_diff_dev = main_properties.keys() - dev_properties.keys()
        main_only = main_diff_prod - dev_properties.keys()
        for key in main_only:
            f.write('{}={}\n'.format(key, main_properties[key]))

        prefix_prod = ''
        prefix_dev = ''
        if option == '1':
            prefix_dev = '#'
        else:
            prefix_prod = '#'

        f.write('#prod\n')
        for key in (main_diff_prod - main_only):
            f.write('{}{}={}\n'.format(prefix_prod, key, main_properties[key]))
        for key, val in prod_properties.items():
            f.write('{}{}={}\n'.format(prefix_prod, key, val))

        f.write('#dev\n')
        for key in (main_diff_dev - main_only):
            f.write('{}{}={}\n'.format(prefix_dev, key, main_properties[key]))
        for key, val in dev_properties.items():
            f.write('{}{}={}\n'.format(prefix_dev, key, val))


def choose_properties():
    lines = [first_line]
    case = ''
    for line in f0:
        if line.startswith('#prod\n'):
            case = '1'
            lines.append(line)
        elif line.startswith('#dev\n'):
            case = '2'
            lines.append(line)
        elif case == '':
            lines.append(line)
        elif case == option:
            if line.startswith('#'):
                line = line.strip('#')
            lines.append(line)
        elif case != option:
            if not line.startswith('#'):
                line = '{}{}'.format('#', line)
            lines.append(line)
    f0.close()
    with open(uri, 'w') as f:
        f.writelines(lines)


try:
    project = sys.argv[1]
except:
    project = input('''choose project:
    1. mapi-alfastar
    2. mapi-cms
    3. mapi-gateway
    4. mapi-member
    5. mapi-product
    6. mapi-promotion
    ''')

if project == '1':
    base_uri = 'ms-mapi-alfastar'
elif project == '2':
    base_uri = 'ms-mapi-cms'
elif project == '3':
    base_uri = 'ms-mapi-gateway'
elif project == '4':
    base_uri = 'ms-mapi-member'
elif project == '5':
    base_uri = 'ms-mapi-product'
elif project == '6':
    base_uri = 'ms-mapi-promotion'
else:
    raise Exception('unacceptable!')

try:
    option = sys.argv[2]
except:
    option = input('''choose properties:
    1. prod
    2. dev (default)
    ''')

if option == '':
    option = '2'
if option not in ('1', '2'):
    raise Exception('unacceptable!')

my_dict = {'1': 'production', '2': 'development'}
print('build properties for {}'.format(base_uri))
print('active profile: {}'.format(my_dict[option]))
uri = '{}/src/main/resources/application.properties'.format(base_uri)
f0 = open(uri, 'r')
first_line = f0.readline()
if first_line.startswith('#built'):
    choose_properties()
else:
    build_properties()
print('<<<<<<<<<< done >>>>>>>>>>')
