


class Train:
    
    def __init__(self, train_no, train_name, total_seats):
        self.train_no = train_no
        self.train_name = train_name
        self.total_seats = total_seats
        self.available_seats = total_seats
        
    
    def book_seats(self):
         
        if self.available_seats > 0:
            seat_no = self.total_seats - self.available_seats + 1
            print(f"You have got a confirmed ticket with seat_no {seat_no} \n")
            self.available_seats -= 1
            
        else:
            print("No available_seat, Please try for another train \n")

    
    
    def display_status(self):
        print(f"Train name is {self.train_name}")
        print(f"Available seats is {self.available_seats}")
        
    
    def __str__(self):
        return f"[Train_no = {self.train_no}, train_name = {self.train_name}, total_seats = {self.total_seats}, avialable_seats = {self.available_seats}]"
        
