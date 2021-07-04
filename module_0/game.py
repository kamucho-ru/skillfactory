import numpy as np


def score_game(game_core):
    '''
    Запускаем игру 1000 раз, чтобы узнать, как быстро игра угадывает число
    '''
    count_ls = []
    # фиксируем RANDOM SEED, чтобы ваш эксперимент был воспроизводим!
    np.random.seed(1)
    random_array = np.random.randint(1, 101, size=(1000))
    for number in random_array:
        count_ls.append(game_core(number))
    score = int(np.mean(count_ls))
    print(f"Ваш алгоритм угадывает число в среднем за {score} попыток")
    return(score)


def game_core_v1(number):
    '''Просто угадываем на random, никак не используя информацию о
    больше или меньше.
    Функция принимает загаданное число и возвращает число попыток'''
    count = 0
    while True:
        count += 1
        predict = np.random.randint(1, 101)  # предполагаемое число
        if number == predict:
            return count  # выход из цикла, если угадали


def game_core_v2(number):
    '''
    Сначала устанавливаем любое random число, а потом уменьшаем или
    увеличиваем его в зависимости от того, больше оно или меньше нужного.
    Функция принимает загаданное число и возвращает число попыток
    '''
    count = 1
    predict = np.random.randint(1, 101)
    while number != predict:
        count += 1
        if number > predict:
            predict += 1
        elif number < predict:
            predict -= 1
    return(count)  # выход из цикла, если угадали


def game_core_v3(number):
    '''
    Будем двигаться из середины диапазона, каждый раз в два раза уменьшая шаг.
    Функция принимает загаданное число и возвращает число попыток
    '''
    count = 1
    range_from, range_to = 1, 101
    # изначально шаг равен первоначальной догадке
    delta = predict = int((range_to - range_from) / 2)
    while number != predict:
        count += 1
        # делим предыдущий шаг пополам, минимум - единица
        delta = max(int(delta/2), 1)
        if number > predict:
            predict += delta
        else:
            predict -= delta
    return(count)  # выход из цикла, если угадали


# запускаем
score_game(game_core_v1)
score_game(game_core_v2)
score_game(game_core_v3)
