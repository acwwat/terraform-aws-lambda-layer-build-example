import numpy as np

def lambda_handler(event, context):
    numbers = []
    for i in range(10):
        numbers.append(np.random.randint(1, 100))
    avg = np.mean(numbers)
    return {
        'message': f'Average of 10 random numbers between 1 and 100: {str(avg)}'
    }
