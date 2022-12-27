extends Node

class_name EvidenceHolder

# number of evidence per page
const PAGE_LIMIT = 8

# index for which page we're on

var page_index : int
var closeup_index: int

# guaranteed to have at least 1 page
var pages = []
var all_evidence = []

func _init():
	pages.append([])
	page_index = 0

func add_evidence(evidence):
	for page in pages:
		# find first open page
		if(page.size() < PAGE_LIMIT):
			page.append(evidence)
			all_evidence.append(evidence)
			return
	
	# we only get to this point if there were no empty pages
	pages.append([evidence])
	all_evidence.append(evidence)


# remove all evidence listed in the provided evidence array
# array is an array of evidence name strings
func remove_evidence(evidence_names: Array):
	var all_ev = []
	
	# store all evidence but the one we want removed
	for page in pages:
		for evidence in page:
			if(!evidence_names.has(evidence.ev_name)):
				all_ev.append(evidence)
	
	pages = [[]]
	all_evidence = []
	
	# re-organize our evidence by re-adding everything back in
	for evidence in all_ev:
		add_evidence(evidence)

func set_closeup_index(evidence):
	closeup_index = all_evidence.bsearch(evidence)
	
func get_evidence_at_current_index():
	return pages[page_index]

func get_evidence_at_closeup_index():
	return all_evidence[closeup_index]
	

