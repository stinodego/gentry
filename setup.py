from setuptools import setup, find_packages

setup(
    name='poems',
    version='0.1.0',
    description='Generate various types of poems.',
    url='https://gitlab.com/stijndeg/poems',
    author='Stijn de Gooijer',
    author_email='stijndegooijer@gmail.com',
    packages=find_packages(),

    python_requires='~=3.8',
    install_requires=[
        'fastapi',
        'uvicorn',
        'jinja2',
        'aiofiles',
    ],

    extras_require={
        'dev': [],
        'test': ['coverage'],
    },
)
