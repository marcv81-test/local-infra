import jinja2
import os
import shutil
import subprocess

# Directory this script lives in.
base_dir = os.path.dirname(os.path.abspath(__file__))

# Other directories.
build_dir = '%s/build' % base_dir
templates_dir = '%s/templates' % base_dir
images_dir = os.path.realpath('%s/../resources/images' % base_dir)
keys_dir = os.path.realpath('%s/../resources/keys' % base_dir)

# Shares the packer cache directory.
packer_cache_dir = '%s/packer_cache' % base_dir
os.environ['PACKER_CACHE_DIR'] = packer_cache_dir

# Empties the build directory. Creates it if required.
def empty_build_dir():
    delete_build_dir()
    os.mkdir(build_dir)

# Deletes the build directory.
def delete_build_dir():
    shutil.rmtree(build_dir, ignore_errors=True)

# Renders the templates into the build directory.
def render_templates(variables):
    loader = jinja2.FileSystemLoader(templates_dir)
    env = jinja2.Environment(loader=loader)
    for filename in os.listdir(templates_dir):
        template = env.get_template(filename)
        output_filename = '%s/%s' % (build_dir, filename)
        with open(output_filename, 'w') as stream:
            stream.write(template.render(variables))

# Runs packer in the build directory.
def run_packer():
    os.chdir(build_dir)
    tokens = ['packer', 'build' ,'packer.json']
    process = subprocess.Popen (tokens, shell=False)
    process.communicate()

# Moves the image away from the build dir.
def save_image(filename):
    shutil.move(
        '%s/output-qemu/packer-qemu' % build_dir,
        '%s/%s' % (images_dir, filename))

# Reads the SSH keys.
def read_keys():
    public_key_filename = '%s/id_ubuntu.pub' % keys_dir
    private_key_filename = '%s/id_ubuntu' % keys_dir
    with open(public_key_filename) as stream:
        public_key = stream.read().strip()
    return public_key, private_key_filename


if __name__ == '__main__':

    # Configuration.
    public_key, private_key_filename = read_keys()
    image_filename = 'packer.img'
    variables = {
        'public_key': public_key,
        'private_key_file': private_key_filename,
        'disk_size': '5G',
    }

    empty_build_dir()
    render_templates(variables)
    run_packer()
    save_image(image_filename)
    delete_build_dir()
