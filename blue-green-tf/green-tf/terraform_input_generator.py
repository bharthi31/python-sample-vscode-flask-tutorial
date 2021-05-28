import argparse
import json
import os


class TerraformInputGenerator(object):
    @staticmethod
    def populate_env(input_params):
        with open(input_params.config_file) as json_file:
            json_data = json.load(json_file)
            for param, value in json_data.iteritems():
                os.environ[param] = value
                print('##vso[task.setvariable variable={};]${}'.format(param, value))

            for param in json_data.keys():
                print("{} = {}".format(param, os.environ.get(param, 'Oops!! Value not set')))


def main(input_params):
    TerraformInputGenerator.populate_env(input_params)


def parse_arguments():
    parser = argparse.ArgumentParser(description='Terraform input generator')
    parser.add_argument('--config_file', nargs='?', default=None,
                        help='Config.json path')
    return parser.parse_args()


if __name__ == "__main__":
    try:
        arguments = parse_arguments()
        main(arguments)
    except Exception as e:
        print('Exception occurred with reason: {}'.format(e))
