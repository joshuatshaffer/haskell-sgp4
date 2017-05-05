from mpl_toolkits.mplot3d import axes3d
import matplotlib.pyplot as plt

fig = plt.figure ()
ax = fig.add_subplot (111, projection='3d')

with open('out.txt', 'r') as f:
    data = ((float(number) for number in line.split()) for line in f)
    data = list(map(list, zip(*data)))

X, Y, Z = data[1], data[2], data[3]

ax.plot_wireframe (X,Y,Z)

with open('test.txt', 'r') as f:
    data = ((float(number) for number in line.split()) for line in f)
    data = list(map(list, zip(*data)))

X, Y, Z = data[1], data[2], data[3]

ax.plot_wireframe (X,Y,Z)

plt.show ()
