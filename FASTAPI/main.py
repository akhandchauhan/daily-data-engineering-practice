from passenger import Passenger
from train import Train
from ticket import Ticket

# create objects
passenger = Passenger(1, "Prashant", 23, "male")
train = Train(2343, "Rapti Sagar Express", 2)

# booking
seat_no = train.book_seats()

if seat_no is not None:
    ticket = Ticket(101, passenger, train, seat_no, "CONFIRMED")
else:
    ticket = Ticket(101, passenger, train, None, "WAITLIST")

print(ticket)
train.display_status()
