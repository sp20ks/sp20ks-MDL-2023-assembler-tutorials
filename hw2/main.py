import io
import tokenize as t
from operator import itemgetter
import string

letters = string.ascii_lowercase + string.ascii_uppercase + "_"

serv_words = {
    "(": "(_open_par",
    ")": ")_close_par",
    ",": ",_comma",
    ";": ";_semicolon",
    "scanf": "s_func",
    "printf": "p_func",
    "&": "&_ampersand"
}

transition_io = {
    "s_func": [1, "E", "E", "E", "E", "E",  "E", "E", "E", "E"],
    "p_func": [3, "E", "E", "E", "E", "E",  "E", "E", "E", "E"],
    "(_open_par": ["E", 2, "E", 4,  "E",  "E", "E", "E", "E"],
    "format_seq_s": ["E", "E", 5, "E", 5, "E", "E", "E", "E"],
    "format_seq_p": ["E", "E", "E", "E", 5, "E", "E", "E", "E"],
    ",_comma": ["E", "E", "E", "E", "E", 6, "E", 6, "E"],
    "&_ampersand": ["E", "E", "E", "E", "E", "E", 6, "E", "E"],
    "variable": ["E", "E", "E", "E", "E", "E", 7, "E", "E"],
    ")_close_par": ["E", "E", "E", "E", "E", "E", "E", 8, "E"],
    ";_semicolon": ["E", "E", "E", "E", "E", "E", "E", "E", "K"]
}

serv_words_quoted_text = {
    "%": "%_percentage",
    "d": "d_format",
    "s": "s_format",
    "c": "c_format",
    "f": "f_format",
    '"': '"_quote'
}

format_printf_transition = {
    "sequence": ["E", 3, "E", 3],
    "%_percentage" : ["E", 2, "E", 2],
    "d_format" : ["E", "E", 3, "E"],
    "s_format": ["E", "E", 3, "E"],
    "c_format": ["E", "E", 3, "E"],
    "f_format": ["E", "E", 3, "E"],
    '"_quote': [1, "E", "E", "K"],
    "digit": ["E", "E", 2, "E"]
}

format_scanf_transition = {
    "%_percentage" : ["E", 2, "E", 2],
    "d_format" : ["E", "E", 3, "E"],
    "s_format": ["E", "E", 3, "E"],
    "c_format": ["E", "E", 3, "E"],
    "f_format": ["E", "E", 3, "E"],
    '"_quote': [1, "E", "E", "K"],
    "digit": ["E", "E", 2, "E"]
}

def split(data):
    tokens = t.tokenize(io.BytesIO(data.strip().encode()).readline)
    next(tokens)  # первый токен содержит информацию о кодировке файла/потока
    return list(map(itemgetter(1), tokens))[:-2]


def tokenize(data):
    res = [serv_words.get(word) for word in data] # заменили все слова
    for i in range(len(res)):
        if res[i] is None:
            if check_sequence(data[i]):
                res[i] = "variable"
            else:
                if data[i][0] == '"' and data[i][-1] == '"':
                    # подготовка к токенизации кавычек
                    splited_quoted_string = split(data[i][1:-1])
                    splited_quoted_string.insert(0, '"') # добавляем в лист токенов в начало кавычки
                    splited_quoted_string.append('"') # добавляем в лист токенов в конец кавычки
                    token_quoted_string = [serv_words_quoted_text.get(word) for word in splited_quoted_string]  # заменили все слова на токены
                    # если есть None, то эти элементы заменяем на sequence
                    for j in range(len(token_quoted_string)):
                        if token_quoted_string[j] is None:
                            if splited_quoted_string[j].isdigit():
                                token_quoted_string[j] = "digit"
                            else:
                                token_quoted_string[j] = "sequence"
                    res[i] = what_format_sequence(token_quoted_string)
                    if res[i] is None:
                        print("Ошибка в форматной строке")
                        exit(0)
                    # должен быть вызов функции проверки формата (текста в кавычках)
                else:
                    print("Синтаксическая ошибка в слове", data[i] + data[i + 1])
                    exit(0)
    return res

def check_sequence(seq):
    if seq[0] in letters:
        return True
    else:
        return False

def what_format_sequence(seq):
    state = 0
    if "sequence" in seq:
        # начинаем проверку автомата текста в кавычках для printf
        for elem in seq:
            state = format_printf_transition.get(elem)[state]
            if state == "E":
                return None
        return "format_seq_p"
    else:
        # начинаем проверку автомата текста в кавычках для scanf
        for elem in seq:
            state = format_scanf_transition.get(elem)[state]
            if state == "E":
                return None
        return "format_seq_s"

try:
    line = split(input("Введите строку: "))
    print("Введенная строка:", line)
    line_tok = tokenize(line)
    print("Токен:", line_tok)

    # начало проверки
    state = 0
    for tok in line_tok:
        state = transition_io.get(tok)[state]
        if state == "K":
            print("Ура! Строка разобрана. Ошибок нет.")
            exit(0)
        if state == "E":
            print("Встречена ошибка: " + tok)
            exit(0)

except Exception:
    print("Упс! Что-то пошло не так. Некорректный ввод :(")
