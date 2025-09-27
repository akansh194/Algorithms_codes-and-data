import csv


class Node:
    def __init__(self, data):
        self.data = data  
        self.next = None


class MemoryDB:
    def __init__(self):
        self.head = None
        self.headers = []

    
    def get_data(self, filename):
        with open(filename, 'r') as file:
            reader = csv.DictReader(file)
            self.headers = reader.fieldnames
            for row in reader:
                self.insert(row)
    def insert(self, data):
        new_node = Node(data)
        if not self.head:
            self.head = new_node
            return
        temp = self.head
        while temp.next:
            temp = temp.next
        temp.next = new_node
    def bubble_sort(self, key):
        if not self.head:
            return
        swapped = True
        while swapped:
            swapped = False
            current = self.head
            while current.next:
                if current.data[key] > current.next.data[key]:
                    current.data, current.next.data = current.next.data, current.data
                    swapped = True
                current = current.next
    
    def export(self, filename):
        with open(filename, 'w', newline='') as file:
            writer = csv.DictWriter(file, fieldnames=self.headers)
            writer.writeheader()
            self.recurse(writer, self.head)

    def recurse(self, writer, node):
        if not node:
            return
        writer.writerow(node.data)
        self.recurse(writer, node.next)
db = MemoryDB()
db.get_data("student-data.csv")

print("Sorting by 'age' using Bubble Sort...")
db.bubble_sort("age")
db.export("sorted_bubble.csv")


