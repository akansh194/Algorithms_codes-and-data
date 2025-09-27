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
    
    def insertion_sort(self, key):
        sorted_head = None
        current = self.head
        while current:
            next_node = current.next
            if not sorted_head or sorted_head.data[key] >= current.data[key]:
                current.next = sorted_head
                sorted_head = current
            else:
                temp = sorted_head
                while temp.next and temp.next.data[key] < current.data[key]:
                    temp = temp.next
                current.next = temp.next
                temp.next = current
            current = next_node
        self.head = sorted_head
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

print("Sorting by 'age' using Insertion Sort...")
db.insertion_sort("age")
db.export("sorted_insertion.csv")
