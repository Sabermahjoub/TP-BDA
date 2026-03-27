import itertools

def printDependencies(F):
    for alpha, beta in F:
        print(alpha, "->", beta)

def printRelations(T):
    for R in T:
        print(R)

def powerSet(inputset):
    result = []
    for r in range(1, len(inputset)+1):
        result += list(map(set, itertools.combinations(inputset, r)))
    return result

def computeAttributeClosure(F, K):
    K_plus = set(K)
    while True:
        old = set(K_plus)
        for alpha, beta in F:
            if alpha.issubset(K_plus):
                K_plus |= beta
        if old == K_plus:
            break
    return K_plus

def isDependency(F, alpha, beta):
    return beta.issubset(computeAttributeClosure(F, alpha))

def isSuperKey(F, R, K):
    return R.issubset(computeAttributeClosure(F, K))

def isCandidateKey(F, R, K):
    if not isSuperKey(F, R, K):
        return False
    for a in K:
        if isSuperKey(F, R, K - {a}):
            return False
    return True

def computeAllCandidateKeys(F, R):
    return [K for K in powerSet(R) if isCandidateKey(F, R, K)]

def computeAllSuperKeys(F, R):
    return [K for K in powerSet(R) if isSuperKey(F, R, K)]

def computeOneCandidateKey(F, R):
    K = set(R)
    for a in list(K):
        if isSuperKey(F, R, K - {a}):
            K.remove(a)
    return K

def isBCNFRelation(F, R):
    for K in powerSet(R):
        K_plus = computeAttributeClosure(F, K)
        if not R.issubset(K_plus):
            if (K_plus - K) & R:
                return False
    return True