#!/usr/bin/env python3
import click
import requests
import time
import os

@click.command()
@click.option('--session-cookie', '-s', required=True, help='Session cookie for AoC website')
@click.option('--year', '-y', required=True, type=click.IntRange(2015,2024), help='Year of Advent of Code')
@click.option('--day', '-d', required=True, type=click.IntRange(1,25), help='First day to fetch')
@click.option('--n-days', '-n', type=click.IntRange(1,25), default=1)
def download_inputs(session_cookie, year, day, n_days):
    days = range(day, min(day + n_days, 25))
    year = int(year)
    cookies = {'session' : session_cookie}
    url_of_day = lambda d: f'https://adventofcode.com/{year}/day/{d}/input'
    home = os.getenv('HOME')
    target_dir = f'{home}/.aoc_data/{year}'
    os.makedirs(target_dir, exist_ok=True)
    for i in days:
        url = url_of_day(i)
        response = requests.get(url, cookies=cookies)
        if response.status_code == 200:
            print(f'Got input of day {i}')
        else:
            print(f'Request for day {i} failed with status code {response.status_code}')
        
        file_path = f'{home}/.aoc_data/{year}/day{i}.in'
        with open(file_path, 'w') as file:
            file.write(response.text)

        time.sleep(0.5)

if __name__ == '__main__':
    download_inputs()
