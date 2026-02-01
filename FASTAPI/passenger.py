


class Passenger:
    
    def __init__(self, passenger_id, name, age, gender):
        self.passenger_id = passenger_id
        self.name = name
        self.age = age
        self.gender = gender
    
    def display_info(self):
        print(f"Passenger_name is {self.name}")
        print(f"{self.name} age is {self.age}")
        print(f"Passenger gender is {self.gender}")
    
    def __str__(self):
        return f"Passenger[ID={self.passenger_id}, Name={self.name}, Age={self.age}]"


