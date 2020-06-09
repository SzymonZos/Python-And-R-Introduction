# Task 1
class StatePool:

    def __init__(self):
        self.__states = {}

    def get_instance(self, cls):
        if cls not in self.__states:
            self.__states[cls] = cls()
        return self.__states[cls]


# Task 2
class HeroState:

    __state_pool = StatePool()

    @classmethod
    def get_instance(cls):
        return HeroState.__state_pool.get_instance(cls)


# Task 3
class Standing(HeroState):

    def on_event(self, event: str):
        if event == "go":
            return Moving.get_instance()
        elif event == "shoot":
            Shooting.previous_state = self
            return Shooting.get_instance()
        else:
            return self

    def __str__(self):
        return "Hero is standing"


class Moving(HeroState):

    def on_event(self, event: str):
        if event == "stop":
            return Standing.get_instance()
        elif event == "shoot":
            Shooting.previous_state = self
            return Shooting.get_instance()
        else:
            return self

    def __str__(self):
        return "Hero is moving"


class Shooting(HeroState):

    previous_state = Standing()

    def on_event(self, event: str):
        return self.previous_state

    def __str__(self):
        return "Hero is shooting"


# Task 4
class Hero:

    def __init__(self):
        self.__current_state = Standing()

    def process_events(self):
        while True:
            print(self.__current_state)
            user_input = input('Select action: ')
            if user_input == 'exit':
                break
            else:
                self.__current_state = \
                    self.__current_state.on_event(user_input)


def main():
    hero = Hero()
    hero.process_events()


if __name__ == "__main__":
    main()
