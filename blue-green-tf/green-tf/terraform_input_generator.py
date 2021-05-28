import json
import os


class TerraformInputGenerator(object):
    @staticmethod
    def populate_env():
        with open("config,json") as json_file:
            json_data = json.load(json_file)
            for param, value in json_data.iteritems():
                os.environ[param] = value
                print('##vso[task.setvariable variable={};]${}'.format(param, value))

            for param in json_data.keys():
                print("{} = {}".format(param, os.environ.get(param, 'Oops!! Value not set')))


def main():
    TerraformInputGenerator.populate_env()


if __name__ == "__main__":
    try:
        main()
    except Exception as e:
        print('Exception occurred with reason: {}'.format(e))
