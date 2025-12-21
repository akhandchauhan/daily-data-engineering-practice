from train import Train
from passenger import Passenger


class Ticket:

    def __init__(self, ticket_id, passenger, train, seat_no, status):
        self.ticket_id = ticket_id
        self.passenger = passenger      # Passenger object
        self.train = train              # Train object
        self.seat_no = seat_no
        self.status = status

    def __str__(self):
        return (
            f"Ticket[ID={self.ticket_id}, "
            f"Passenger={self.passenger.name}, "
            f"Train={self.train.train_name}, "
            f"Seat={self.seat_no}, "
            f"Status={self.status}]"
        )



